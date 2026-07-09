//
//  MainViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import Foundation

final class MainViewModel: BaseViewModel<EmptyViewState> {
    weak var router: MainRouting?

    func didSelectMovie(id: UUID) {
        router?.openMovieDetails(id)
    }
}
