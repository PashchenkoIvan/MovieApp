//
//  Movie.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

struct Movie: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let popularity: Double

    var releaseYear: String? {
        releaseDate?.split(separator: "-").first.map(String.init)
    }
}
