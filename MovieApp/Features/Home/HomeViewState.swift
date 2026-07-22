//
//  HomeViewState.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

enum HomeViewState: ViewState, Equatable {
    case idle
    case loading
    case content(HomeMovies)
    case empty
    case failed(message: String)

    var isLoading: Bool {
        self == .loading
    }
}
