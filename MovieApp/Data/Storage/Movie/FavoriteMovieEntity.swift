//
//  FavoriteMovieEntity.swift
//  MovieApp
//
//  Created by Ivan P. on 16/07/2026.
//

import Foundation
import SwiftData

// MARK: - Favorite Movie Entity

/// SwiftData entity for a favorite movie.
@Model
final class FavoriteMovieEntity {
    @Attribute(.unique) var movieID: Int
    var title: String
    var posterPath: String?
    var overview: String
    var releaseDate: String?
    var voteAverage: Double
    var createdAt: Date

    init(
        movieID: Int,
        title: String,
        posterPath: String?,
        overview: String,
        releaseDate: String?,
        voteAverage: Double,
        createdAt: Date = Date()
    ) {
        self.movieID = movieID
        self.title = title
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.createdAt = createdAt
    }
}
