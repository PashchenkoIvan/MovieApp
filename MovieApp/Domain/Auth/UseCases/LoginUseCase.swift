//
//  LoginUseCase.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

protocol LoginUseCase {
    @discardableResult
    func execute(username: String, password: String) async throws -> AuthSession
}

final class TMDBLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    @discardableResult
    func execute(username: String, password: String) async throws -> AuthSession {
        try await authRepository.login(username: username, password: password)
    }
}

final class FailingLoginUseCase: LoginUseCase {
    private let error: Error

    init(error: Error) {
        self.error = error
    }

    @discardableResult
    func execute(username: String, password: String) async throws -> AuthSession {
        throw error
    }
}
