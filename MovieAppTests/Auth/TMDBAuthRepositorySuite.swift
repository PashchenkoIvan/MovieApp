//
//  TMDBAuthRepositorySuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Testing

@testable import MovieApp

@MainActor
@Suite("TMDBAuthRepository")
struct TMDBAuthRepositorySuite {
    let authAPI = TMDBAuthAPISpy()
    
    @Test("Login completes auth flow and returns session")
    func loginCompletesAuthFlowAndReturnsSession() async throws {
        let sessionDataSource = AuthSessionDataSourceSpy()
        let repository = TMDBAuthRepository(
            authAPI: authAPI,
            sessionDataSource: sessionDataSource
        )

        let session = try await repository.login(
            username: "username",
            password: "password"
        )

        #expect(session == AuthSession(sessionID: "session-id"))
        #expect(authAPI.didCallCreateRequestToken == true)
        #expect(authAPI.validateLoginCalls == [ValidateLoginCall(
            username: "username",
            password: "password",
            requestToken: "request-token"
        )])
        #expect(authAPI.createSessionCalls == ["validated-token"])
        #expect(sessionDataSource.savedSessions == [AuthSession(sessionID: "session-id")])
    }

    @Test("Login passes request token to validate login")
    func loginPassesRequestTokenToValidateLogin() async throws {
        authAPI.createRequestTokenResult = .success("initial-token")
        let repository = makeRepository(authAPI: authAPI)

        _ = try await repository.login(username: "username", password: "password")

        #expect(authAPI.validateLoginCalls.first?.requestToken == "initial-token")
    }

    @Test("Login passes validated token to create session")
    func loginPassesValidatedTokenToCreateSession() async throws {
        authAPI.validateLoginResult = .success("validated-token-value")
        let repository = makeRepository(authAPI: authAPI)

        _ = try await repository.login(username: "username", password: "password")

        #expect(authAPI.createSessionCalls == ["validated-token-value"])
    }

    @Test("Login stops when request token fails")
    func loginStopsWhenRequestTokenFails() async throws {
        authAPI.createRequestTokenResult = .failure(AuthTestError.requestToken)
        let sessionDataSource = AuthSessionDataSourceSpy()
        let repository = makeRepository(
            authAPI: authAPI,
            sessionDataSource: sessionDataSource
        )

        do {
            _ = try await repository.login(username: "username", password: "password")
            Issue.record("Expected request token error")
        } catch AuthTestError.requestToken {
            #expect(authAPI.validateLoginCalls.isEmpty)
            #expect(authAPI.createSessionCalls.isEmpty)
            #expect(sessionDataSource.savedSessions.isEmpty)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Login stops when validate login fails")
    func loginStopsWhenValidateLoginFails() async throws {
        authAPI.validateLoginResult = .failure(AuthTestError.validateLogin)
        let sessionDataSource = AuthSessionDataSourceSpy()
        let repository = makeRepository(
            authAPI: authAPI,
            sessionDataSource: sessionDataSource
        )

        do {
            _ = try await repository.login(username: "username", password: "password")
            Issue.record("Expected validate login error")
        } catch AuthTestError.validateLogin {
            #expect(authAPI.didCallCreateRequestToken == true)
            #expect(authAPI.validateLoginCalls.count == 1)
            #expect(authAPI.createSessionCalls.isEmpty)
            #expect(sessionDataSource.savedSessions.isEmpty)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Login does not save session when create session fails")
    func loginDoesNotSaveSessionWhenCreateSessionFails() async throws {
        authAPI.createSessionResult = .failure(AuthTestError.createSession)
        let sessionDataSource = AuthSessionDataSourceSpy()
        let repository = makeRepository(
            authAPI: authAPI,
            sessionDataSource: sessionDataSource
        )

        do {
            _ = try await repository.login(username: "username", password: "password")
            Issue.record("Expected create session error")
        } catch AuthTestError.createSession {
            #expect(authAPI.didCallCreateRequestToken == true)
            #expect(authAPI.validateLoginCalls.count == 1)
            #expect(authAPI.createSessionCalls.count == 1)
            #expect(sessionDataSource.savedSessions.isEmpty)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Login propagates save session error")
    func loginPropagatesSaveSessionError() async throws {
        let sessionDataSource = AuthSessionDataSourceSpy()
        sessionDataSource.saveSessionError = AuthTestError.saveSession
        let repository = makeRepository(
            authAPI: authAPI,
            sessionDataSource: sessionDataSource
        )

        do {
            _ = try await repository.login(username: "username", password: "password")
            Issue.record("Expected save session error")
        } catch AuthTestError.saveSession {
            #expect(authAPI.didCallCreateRequestToken == true)
            #expect(authAPI.validateLoginCalls.count == 1)
            #expect(authAPI.createSessionCalls.count == 1)
            #expect(sessionDataSource.savedSessions.isEmpty)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private extension TMDBAuthRepositorySuite {
    func makeRepository(
        authAPI: TMDBAuthAPISpy = TMDBAuthAPISpy(),
        sessionDataSource: AuthSessionDataSourceSpy = AuthSessionDataSourceSpy()
    ) -> TMDBAuthRepository {
        TMDBAuthRepository(
            authAPI: authAPI,
            sessionDataSource: sessionDataSource
        )
    }
}
