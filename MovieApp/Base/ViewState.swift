//
//  ViewState.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

protocol ViewState {
    var isLoading: Bool { get }
}

extension ViewState {
    var isLoading: Bool { false }
}

enum EmptyViewState: ViewState {
    case idle
}
