//
//  TMDBMovieTrailerDTO.swift
//  MovieApp
//
//  Created by Ivan P. on 22/07/2026.
//

import Foundation

struct TMDBMovieTrailerDTO: Decodable, Equatable, Sendable {
    let id: String?
    let name: String?
    let key: String?
    let site: String?
    let type: String?
    let official: Bool?
    let publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case key
        case site
        case type
        case official
        case publishedAt = "published_at"
    }
}
