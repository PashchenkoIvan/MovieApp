//
//  LoginViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import Foundation

@MainActor
final class LoginViewModel: BaseViewModel<LoginViewState> {
    weak var router: LoginRouting?

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        super.init(initialState: .idle)
    }

    func login(username: String, password: String) {
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !username.isEmpty, !password.isEmpty else {
            setState(.failed("Username and password are required."))
            return
        }

        setState(.loading)

        Task { [weak self] in
            guard let self else { return }

            do {
                try await loginUseCase.execute(username: username, password: password)
                setState(.authenticated)
                router?.openMain()
            } catch {
                setState(.failed(error.localizedDescription))
            }
        }
    }
}
