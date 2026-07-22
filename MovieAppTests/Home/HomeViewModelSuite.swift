//
//  HomeViewModelSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("HomeViewModel")
struct HomeViewModelSuite {
    @Test("Init uses idle state")
    func initUsesIdleState() {
        let viewModel = HomeViewModel(loadHomeMoviesUseCase: LoadHomeMoviesUseCaseSpy())

        #expect(viewModel.state == .idle)
    }

    @Test("View did load emits loading and content")
    func viewDidLoadEmitsLoadingAndContent() async {
        let homeMovies = HomeMovies.fixture()
        let useCase = LoadHomeMoviesUseCaseSpy(result: .success(homeMovies))
        let viewModel = HomeViewModel(loadHomeMoviesUseCase: useCase)
        var states: [HomeViewState] = []
        viewModel.onStateChanged = { states.append($0) }

        viewModel.viewDidLoad()
        await waitUntil { viewModel.state == .content(homeMovies) }

        #expect(states == [.loading, .content(homeMovies)])
        #expect(useCase.executeCallCount == 1)
    }

    @Test("Empty response emits empty state")
    func emptyResponseEmitsEmptyState() async {
        let useCase = LoadHomeMoviesUseCaseSpy(result: .success(HomeMovies(featured: nil, trailers: [], popular: [], topRated: [], upcoming: [])))
        let viewModel = HomeViewModel(loadHomeMoviesUseCase: useCase)

        viewModel.viewDidLoad()
        await waitUntil { viewModel.state == .empty }

        #expect(viewModel.state == .empty)
    }

    @Test("Failure emits failed state")
    func failureEmitsFailedState() async {
        let useCase = LoadHomeMoviesUseCaseSpy(result: .failure(HomeTestError.loadFailed))
        let viewModel = HomeViewModel(loadHomeMoviesUseCase: useCase)

        viewModel.viewDidLoad()
        await waitUntil {
            if case .failed = viewModel.state { return true }
            return false
        }

        #expect(viewModel.state == .failed(message: HomeTestError.loadFailed.localizedDescription))
    }

    @Test("Retry loads again")
    func retryLoadsAgain() async {
        let useCase = LoadHomeMoviesUseCaseSpy(result: .failure(HomeTestError.loadFailed))
        let viewModel = HomeViewModel(loadHomeMoviesUseCase: useCase)

        viewModel.viewDidLoad()
        await waitUntil {
            if case .failed = viewModel.state { return true }
            return false
        }

        useCase.result = .success(.fixture())
        viewModel.retry()
        await waitUntil {
            if case .content = viewModel.state { return true }
            return false
        }

        #expect(useCase.executeCallCount == 2)
    }
}

private final class LoadHomeMoviesUseCaseSpy: LoadHomeMoviesUseCase {
    var result: Result<HomeMovies, Error>
    private(set) var executeCallCount = 0

    init(result: Result<HomeMovies, Error> = .success(.fixture())) {
        self.result = result
    }

    func execute() async throws -> HomeMovies {
        executeCallCount += 1
        return try result.get()
    }
}

private enum HomeTestError: Error {
    case loadFailed
}

private extension HomeMovies {
    static func fixture() -> HomeMovies {
        let movie = Movie(
            id: 42,
            title: "Long Movie Title That Still Needs To Wrap Nicely",
            overview: "A focused overview.",
            posterPath: "/poster.jpg",
            backdropPath: "/backdrop.jpg",
            releaseDate: "2026-07-21",
            voteAverage: 8.6,
            popularity: 120
        )

        return HomeMovies(
            featured: movie,
            trailers: [MovieTrailer(
                id: "trailer-id",
                movieID: movie.id,
                movieTitle: movie.title,
                name: "Official Trailer",
                key: "youtube-key",
                site: "YouTube",
                type: "Trailer",
                isOfficial: true
            )],
            popular: [movie],
            topRated: [movie],
            upcoming: [movie]
        )
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
