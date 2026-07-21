//
//  LoginViewModelSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("LoginViewModel")
struct LoginViewModelSuite {
    @Test("Init uses idle state")
    func initUsesIdleState() {
        let viewModel = LoginViewModel(loginUseCase: LoginUseCaseSpy())

        #expect(viewModel.state == .idle)
    }

    @Test("Login with empty username fails without calling use case")
    func loginWithEmptyUsernameFailsWithoutCallingUseCase() {
        let loginUseCase = LoginUseCaseSpy()
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)

        viewModel.login(username: "", password: "password")

        #expect(viewModel.state == .failed(messageKey: "login.error.credentialsRequired"))
        #expect(loginUseCase.executeCalls.isEmpty)
    }

    @Test("Login with empty password fails without calling use case")
    func loginWithEmptyPasswordFailsWithoutCallingUseCase() {
        let loginUseCase = LoginUseCaseSpy()
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)

        viewModel.login(username: "username", password: "")

        #expect(viewModel.state == .failed(messageKey: "login.error.credentialsRequired"))
        #expect(loginUseCase.executeCalls.isEmpty)
    }

    @Test("Login trims credentials before calling use case")
    func loginTrimsCredentialsBeforeCallingUseCase() async {
        let loginUseCase = LoginUseCaseSpy()
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)

        viewModel.login(username: "  username  ", password: "  password  ")
        await waitUntil { !loginUseCase.executeCalls.isEmpty }

        #expect(loginUseCase.executeCalls == [LoginUseCaseExecuteCall(
            username: "username",
            password: "password"
        )])
    }

    @Test("Login success emits loading and authenticated states")
    func loginSuccessEmitsLoadingAndAuthenticatedStates() async {
        let loginUseCase = LoginUseCaseSpy()
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        var states: [LoginViewState] = []
        viewModel.onStateChanged = { states.append($0) }

        viewModel.login(username: "username", password: "password")
        await waitUntil { viewModel.state == .authenticated }

        #expect(states == [.loading, .authenticated])
        #expect(viewModel.state == .authenticated)
    }

    @Test("Login success opens main")
    func loginSuccessOpensMain() async {
        let loginUseCase = LoginUseCaseSpy()
        let router = LoginRouterSpy()
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        viewModel.router = router

        viewModel.login(username: "username", password: "password")
        await waitUntil { router.openMainCallCount == 1 }

        #expect(router.openMainCallCount == 1)
    }

    @Test("Login failure emits loading and failed states")
    func loginFailureEmitsLoadingAndFailedStates() async {
        let loginUseCase = LoginUseCaseSpy()
        loginUseCase.result = .failure(AuthTestError.login)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        var states: [LoginViewState] = []
        viewModel.onStateChanged = { states.append($0) }

        viewModel.login(username: "username", password: "password")
        await waitUntil {
            if case .failed = viewModel.state {
                return true
            }
            return false
        }

        #expect(states == [.loading, .failed(messageKey: AuthTestError.login.localizedDescription)])
        #expect(viewModel.state == .failed(messageKey: AuthTestError.login.localizedDescription))
    }

    @Test("Login failure does not open main")
    func loginFailureDoesNotOpenMain() async {
        let loginUseCase = LoginUseCaseSpy()
        loginUseCase.result = .failure(AuthTestError.login)
        let router = LoginRouterSpy()
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        viewModel.router = router

        viewModel.login(username: "username", password: "password")
        await waitUntil {
            if case .failed = viewModel.state {
                return true
            }
            return false
        }

        #expect(router.openMainCallCount == 0)
    }

    @Test("Repeated login replaces previous failed state")
    func repeatedLoginReplacesPreviousFailedState() async {
        let loginUseCase = LoginUseCaseSpy()
        loginUseCase.result = .failure(AuthTestError.login)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)

        viewModel.login(username: "username", password: "password")
        await waitUntil {
            if case .failed = viewModel.state {
                return true
            }
            return false
        }

        loginUseCase.result = .success(AuthSession(sessionID: "session-id"))
        viewModel.login(username: "username", password: "password")
        await waitUntil { viewModel.state == .authenticated }

        #expect(viewModel.state == .authenticated)
    }
}

private func waitUntil(
    timeoutNanoseconds: UInt64 = 500_000_000,
    condition: @MainActor @escaping () -> Bool
) async {
    let intervalNanoseconds: UInt64 = 10_000_000
    var elapsedNanoseconds: UInt64 = 0

    while elapsedNanoseconds < timeoutNanoseconds {
        if await condition() {
            return
        }

        try? await Task.sleep(nanoseconds: intervalNanoseconds)
        elapsedNanoseconds += intervalNanoseconds
    }
}
