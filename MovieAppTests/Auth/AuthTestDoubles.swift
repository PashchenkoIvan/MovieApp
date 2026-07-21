//
//  AuthTestDoubles.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
@testable import MovieApp

final class TMDBAuthAPISpy: TMDBAuthAPIProtocol {
    private(set) var didCallCreateRequestToken = false
    private(set) var validateLoginCalls: [ValidateLoginCall] = []
    private(set) var createSessionCalls: [String] = []

    var createRequestTokenResult: Result<String, Error> = .success("request-token")
    var validateLoginResult: Result<String, Error> = .success("validated-token")
    var createSessionResult: Result<String, Error> = .success("session-id")

    func createRequestToken() async throws -> String {
        didCallCreateRequestToken = true
        return try createRequestTokenResult.get()
    }

    func validateLogin(
        username: String,
        password: String,
        requestToken: String
    ) async throws -> String {
        validateLoginCalls.append(ValidateLoginCall(
            username: username,
            password: password,
            requestToken: requestToken
        ))
        return try validateLoginResult.get()
    }

    func createSession(requestToken: String) async throws -> String {
        createSessionCalls.append(requestToken)
        return try createSessionResult.get()
    }
}

struct ValidateLoginCall: Equatable {
    let username: String
    let password: String
    let requestToken: String
}

final class AuthSessionDataSourceSpy: AuthSessionDataSource {
    private(set) var savedSessions: [AuthSession] = []
    private(set) var didCallGetSession = false
    private(set) var didCallDeleteSession = false

    var saveSessionError: Error?
    var getSessionResult: Result<AuthSession?, Error> = .success(nil)
    var deleteSessionError: Error?

    func saveSession(_ session: AuthSession) throws {
        if let saveSessionError {
            throw saveSessionError
        }
        savedSessions.append(session)
    }

    func getSession() throws -> AuthSession? {
        didCallGetSession = true
        return try getSessionResult.get()
    }

    func deleteSession() throws {
        didCallDeleteSession = true
        if let deleteSessionError {
            throw deleteSessionError
        }
    }
}

final class AuthRepositorySpy: AuthRepository {
    private(set) var loginCalls: [AuthRepositoryLoginCall] = []
    var loginResult: Result<AuthSession, Error> = .success(AuthSession(sessionID: "session-id"))

    func login(username: String, password: String) async throws -> AuthSession {
        loginCalls.append(AuthRepositoryLoginCall(
            username: username,
            password: password
        ))
        return try loginResult.get()
    }
}

struct AuthRepositoryLoginCall: Equatable {
    let username: String
    let password: String
}

enum AuthTestError: Error, Equatable {
    case requestToken
    case validateLogin
    case createSession
    case saveSession
    case login
}
