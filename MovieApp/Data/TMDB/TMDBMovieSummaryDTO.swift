//
//  TMDBMovieSummaryDTO.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

struct TMDBMovieSummaryDTO: Decodable, Equatable, Sendable {
    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let popularity: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case popularity
    }
}
