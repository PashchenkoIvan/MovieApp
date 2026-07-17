//
//  TMDBAuthRepository.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

final class TMDBAuthRepository: AuthRepository {
    private let authAPI: TMDBAuthAPIProtocol
    private let sessionDataSource: AuthSessionKeychainDataSource

    init(
        authAPI: TMDBAuthAPIProtocol,
        sessionDataSource: AuthSessionKeychainDataSource
    ) {
        self.authAPI = authAPI
        self.sessionDataSource = sessionDataSource
    }

    func login(username: String, password: String) async throws -> AuthSession {
        let requestToken = try await authAPI.createRequestToken()
        let validatedToken = try await authAPI.validateLogin(
            username: username,
            password: password,
            requestToken: requestToken
        )
        let sessionID = try await authAPI.createSession(requestToken: validatedToken)
        let session = AuthSession(sessionID: sessionID)

        try sessionDataSource.saveSession(session)

        return session
    }
}
