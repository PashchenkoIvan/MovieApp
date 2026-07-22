//
//  MoviesRepository.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

protocol MoviesRepository {
    func loadHomeMovies() async throws -> HomeMovies
}
