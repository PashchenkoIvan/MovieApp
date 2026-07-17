//
//  FavoriteMovie.swift
//  MovieApp
//
//  Created by Ivan P. on 16/07/2026.
//

import Foundation

// MARK: - Favorite Movie

/// Clean app model for a favorite movie.
struct FavoriteMovie: Equatable {
    let movieID: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String?
    let voteAverage: Double
    let createdAt: Date
}
