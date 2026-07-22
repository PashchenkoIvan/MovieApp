//
//  LoadHomeMoviesUseCase.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

protocol LoadHomeMoviesUseCase {
    func execute() async throws -> HomeMovies
}

final class TMDBLoadHomeMoviesUseCase: LoadHomeMoviesUseCase {
    private let moviesRepository: MoviesRepository

    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }

    func execute() async throws -> HomeMovies {
        try await moviesRepository.loadHomeMovies()
    }
}

final class FailingLoadHomeMoviesUseCase: LoadHomeMoviesUseCase {
    private let error: Error

    init(error: Error) {
        self.error = error
    }

    func execute() async throws -> HomeMovies {
        throw error
    }
}
