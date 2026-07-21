//
//  LoginUseCaseSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Testing

@testable import MovieApp

@MainActor
@Suite("LoginUseCase")
struct LoginUseCaseSuite {
    let authRepository = AuthRepositorySpy()
    
    @Test("Execute calls auth repository login")
    func executeCallsAuthRepositoryLogin() async throws {
        let useCase = TMDBLoginUseCase(authRepository: authRepository)

        try await useCase.execute(
            username: "username",
            password: "password"
        )

        #expect(authRepository.loginCalls == [AuthRepositoryLoginCall(
            username: "username",
            password: "password"
        )])
    }

    @Test("Execute returns auth session")
    func executeReturnsAuthSession() async throws {
        authRepository.loginResult = .success(AuthSession(sessionID: "session-id"))
        let useCase = TMDBLoginUseCase(authRepository: authRepository)

        let session = try await useCase.execute(
            username: "username",
            password: "password"
        )

        #expect(session == AuthSession(sessionID: "session-id"))
    }

    @Test("Execute propagates repository error")
    func executePropagatesRepositoryError() async throws {
        authRepository.loginResult = .failure(AuthTestError.login)
        let useCase = TMDBLoginUseCase(authRepository: authRepository)

        do {
            try await useCase.execute(
                username: "username",
                password: "password"
            )
            Issue.record("Expected repository error")
        } catch AuthTestError.login {
            #expect(authRepository.loginCalls.count == 1)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Failing login use case throws configured error")
    func failingLoginUseCaseThrowsConfiguredError() async throws {
        let useCase = FailingLoginUseCase(error: AuthTestError.login)

        do {
            try await useCase.execute(
                username: "username",
                password: "password"
            )
            Issue.record("Expected configured error")
        } catch AuthTestError.login {
            #expect(true)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
