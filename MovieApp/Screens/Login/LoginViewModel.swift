//
//  LoginViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import Foundation

final class LoginViewModel: BaseViewModel {
    weak var router: LoginRouting?

    func didCompleteLogin() {
        router?.openMain()
    }
}
