//
//  AppDependencyContainer.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

final class AppDependencyContainer {
    let loginUseCase: LoginUseCase

    init() {
        self.loginUseCase = Self.makeLoginUseCase()
    }

    private static func makeLoginUseCase() -> LoginUseCase {
        do {
            let configuration = try TMDBConfiguration.live
            let networkClient = NetworkClient(configuration: configuration)
            let authAPI = TMDBAuthAPI(networkClient: networkClient)
            let authRepository = TMDBAuthRepository(authAPI: authAPI)

            return TMDBLoginUseCase(authRepository: authRepository)
        } catch {
            return FailingLoginUseCase(error: error)
        }
    }
}
