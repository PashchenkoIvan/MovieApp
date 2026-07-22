//
//  AppDependencyContainer.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

// MARK: - App Dependency Container

/// Creates and stores shared app dependencies.
///
/// Coordinators use this container to inject services into ViewModels.
final class AppDependencyContainer {
    let loginUseCase: LoginUseCase
    let loadHomeMoviesUseCase: LoadHomeMoviesUseCase
    let swiftDataStorage: SwiftDataStorage?
    let favoriteMoviesLocalDataSource: FavoriteMoviesLocalDataSource?

    // MARK: - Init

    init() {
        let storage = try? SwiftDataStorage()

        self.swiftDataStorage = storage
        self.favoriteMoviesLocalDataSource = storage.map {
            FavoriteMoviesLocalDataSource(storage: $0)
        }

        do {
            let networkClient = try Self.makeNetworkClient()
            let tmdbListNetworkClient = try Self.makeTMDBListNetworkClient()
            self.loginUseCase = Self.makeLoginUseCase(networkClient: networkClient)
            self.loadHomeMoviesUseCase = Self.makeLoadHomeMoviesUseCase(networkClient: tmdbListNetworkClient)
        } catch {
            self.loginUseCase = FailingLoginUseCase(error: error)
            self.loadHomeMoviesUseCase = FailingLoadHomeMoviesUseCase(error: error)
        }
    }

    // MARK: - Factory Methods

    private static func makeNetworkClient() throws -> NetworkClient {
        let configuration = try TMDBConfiguration.live
        return NetworkClient(configuration: configuration)
    }

    private static func makeTMDBListNetworkClient() throws -> NetworkClient {
        let configuration = try TMDBConfiguration.live
        return NetworkClient(configuration: configuration, decoder: JSONDecoder())
    }

    private static func makeLoginUseCase(networkClient: NetworkClientProtocol) -> LoginUseCase {
        let authAPI = TMDBAuthAPI(networkClient: networkClient)
        let keychainStorage = KeychainStorage()
        let sessionDataSource = AuthSessionKeychainDataSource(keychainStorage: keychainStorage)
        let authRepository = TMDBAuthRepository(
            authAPI: authAPI,
            sessionDataSource: sessionDataSource
        )

        return TMDBLoginUseCase(authRepository: authRepository)
    }

    private static func makeLoadHomeMoviesUseCase(networkClient: NetworkClientProtocol) -> LoadHomeMoviesUseCase {
        let moviesAPI = TMDBMoviesAPI(networkClient: networkClient)
        let moviesRepository = TMDBMoviesRepository(moviesAPI: moviesAPI)

        return TMDBLoadHomeMoviesUseCase(moviesRepository: moviesRepository)
    }
}
