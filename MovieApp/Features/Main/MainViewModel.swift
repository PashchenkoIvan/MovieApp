//
//  MainViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import Foundation

// MARK: - Main ViewModel

/// ViewModel for the main screen.
final class MainViewModel: BaseViewModel<EmptyViewState> {
    weak var router: MainRouting?

    // MARK: - Routing

    func didSelectMovie(id: UUID) {
        router?.openMovieDetails(id)
    }
}
