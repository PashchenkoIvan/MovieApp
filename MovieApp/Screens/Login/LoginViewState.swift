//
//  LoginViewState.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

enum LoginViewState: ViewState, Equatable {
    case idle
    case loading
    case authenticated
    case failed(String)

    var isLoading: Bool {
        self == .loading
    }
}
