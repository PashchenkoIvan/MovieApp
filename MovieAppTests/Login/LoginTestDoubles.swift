//
//  LoginTestDoubles.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

@testable import MovieApp

final class LoginUseCaseSpy: LoginUseCase {
    private(set) var executeCalls: [LoginUseCaseExecuteCall] = []
    var result: Result<AuthSession, Error> = .success(AuthSession(sessionID: "session-id"))

    func execute(username: String, password: String) async throws -> AuthSession {
        executeCalls.append(LoginUseCaseExecuteCall(
            username: username,
            password: password
        ))
        return try result.get()
    }
}

struct LoginUseCaseExecuteCall: Equatable {
    let username: String
    let password: String
}

final class LoginRouterSpy: LoginRouting {
    private(set) var openMainCallCount = 0

    func openMain() {
        openMainCallCount += 1
    }
}
