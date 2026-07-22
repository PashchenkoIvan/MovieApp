//
//  HomeMovies.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

struct HomeMovies: Equatable, Sendable {
    let featured: Movie?
    let trailers: [MovieTrailer]
    let popular: [Movie]
    let topRated: [Movie]
    let upcoming: [Movie]

    var isEmpty: Bool {
        featured == nil && trailers.isEmpty && popular.isEmpty && topRated.isEmpty && upcoming.isEmpty
    }
}
