//
//  MainViewModelSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("MainViewModel")
struct MainViewModelSuite {
    @Test("Init uses idle state")
    func initUsesIdleState() {
        let viewModel = MainViewModel()

        #expect(viewModel.state == .idle)
    }

    @Test("Did select movie opens movie details")
    func didSelectMovieOpensMovieDetails() {
        let router = MainRouterSpy()
        let viewModel = MainViewModel()
        let movieID = UUID()
        viewModel.router = router

        viewModel.didSelectMovie(id: movieID)

        #expect(router.openMovieDetailsCalls == [movieID])
    }

    @Test("Did select movie without router does not crash")
    func didSelectMovieWithoutRouterDoesNotCrash() {
        let viewModel = MainViewModel()

        viewModel.didSelectMovie(id: UUID())

        #expect(viewModel.state == .idle)
    }
}

private final class MainRouterSpy: MainRouting {
    private(set) var openMovieDetailsCalls: [UUID] = []

    func openMovieDetails(_ movieId: UUID) {
        openMovieDetailsCalls.append(movieId)
    }
}
