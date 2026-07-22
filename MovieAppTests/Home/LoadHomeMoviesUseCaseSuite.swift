//
//  LoadHomeMoviesUseCaseSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 22/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("LoadHomeMoviesUseCase")
struct LoadHomeMoviesUseCaseSuite {
    @Test("Execute returns repository home movies")
    func executeReturnsRepositoryHomeMovies() async throws {
        let homeMovies = HomeMovies(featured: nil, trailers: [], popular: [], topRated: [], upcoming: [])
        let repository = MoviesRepositorySpy(result: .success(homeMovies))
        let useCase = TMDBLoadHomeMoviesUseCase(moviesRepository: repository)

        let result = try await useCase.execute()

        #expect(result == homeMovies)
        #expect(repository.loadHomeMoviesCallCount == 1)
    }

    @Test("Execute propagates repository error")
    func executePropagatesRepositoryError() async throws {
        let repository = MoviesRepositorySpy(result: .failure(LoadHomeMoviesUseCaseTestError.loadFailed))
        let useCase = TMDBLoadHomeMoviesUseCase(moviesRepository: repository)

        do {
            _ = try await useCase.execute()
            Issue.record("Expected repository error")
        } catch LoadHomeMoviesUseCaseTestError.loadFailed {
            #expect(repository.loadHomeMoviesCallCount == 1)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private final class MoviesRepositorySpy: MoviesRepository {
    private let result: Result<HomeMovies, Error>
    private(set) var loadHomeMoviesCallCount = 0

    init(result: Result<HomeMovies, Error>) {
        self.result = result
    }

    func loadHomeMovies() async throws -> HomeMovies {
        loadHomeMoviesCallCount += 1
        return try result.get()
    }
}

private enum LoadHomeMoviesUseCaseTestError: Error {
    case loadFailed
}
