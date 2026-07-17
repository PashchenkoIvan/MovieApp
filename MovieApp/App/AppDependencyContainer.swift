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
    let swiftDataStorage: SwiftDataStorage?
    let favoriteMoviesLocalDataSource: FavoriteMoviesLocalDataSource?

    // MARK: - Init

    init() {
        let storage = try? SwiftDataStorage()

        self.swiftDataStorage = storage
        self.favoriteMoviesLocalDataSource = storage.map {
            FavoriteMoviesLocalDataSource(storage: $0)
        }
        self.loginUseCase = Self.makeLoginUseCase()
    }

    // MARK: - Factory Methods

    private static func makeLoginUseCase() -> LoginUseCase {
        do {
            let configuration = try TMDBConfiguration.live
            let networkClient = NetworkClient(configuration: configuration)
            let authAPI = TMDBAuthAPI(networkClient: networkClient)
            let keychainStorage = KeychainStorage()
            let sessionDataSource = AuthSessionKeychainDataSource(keychainStorage: keychainStorage)
            let authRepository = TMDBAuthRepository(
                authAPI: authAPI,
                sessionDataSource: sessionDataSource
            )

            return TMDBLoginUseCase(authRepository: authRepository)
        } catch {
            return FailingLoginUseCase(error: error)
        }
    }
}
