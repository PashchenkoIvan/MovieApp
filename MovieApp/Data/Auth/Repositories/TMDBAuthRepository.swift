//
//  TMDBAuthRepository.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

final class TMDBAuthRepository: AuthRepository {
    private let authAPI: TMDBAuthAPIProtocol

    init(authAPI: TMDBAuthAPIProtocol) {
        self.authAPI = authAPI
    }

    func login(username: String, password: String) async throws -> AuthSession {
        let requestToken = try await authAPI.createRequestToken()
        let validatedToken = try await authAPI.validateLogin(
            username: username,
            password: password,
            requestToken: requestToken
        )
        let sessionID = try await authAPI.createSession(requestToken: validatedToken)

        return AuthSession(sessionID: sessionID)
    }
}
