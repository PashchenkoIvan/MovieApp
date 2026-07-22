//
//  TMDBMovieSummaryDTOSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("TMDB movie DTOs")
struct TMDBMovieSummaryDTOSuite {
    @Test("Decodes TMDB snake case fields and fractional vote average")
    func decodesSnakeCaseFieldsAndFractionalVoteAverage() throws {
        let data = #"""
        {
          "id": 42,
          "title": "Upcoming Feature",
          "overview": "Overview",
          "poster_path": "/poster.jpg",
          "backdrop_path": "/backdrop.jpg",
          "release_date": "2026-08-14",
          "vote_average": 6.7,
          "popularity": 124.5
        }
        """#.data(using: .utf8)!

        let dto = try JSONDecoder().decode(TMDBMovieSummaryDTO.self, from: data)

        #expect(dto.id == 42)
        #expect(dto.posterPath == "/poster.jpg")
        #expect(dto.backdropPath == "/backdrop.jpg")
        #expect(dto.voteAverage == 6.7)
    }

    @Test("Decodes TMDB trailer fields")
    func decodesTrailerFields() throws {
        let data = #"""
        {
          "id": "video-id",
          "name": "Official Trailer",
          "key": "youtube-key",
          "site": "YouTube",
          "type": "Trailer",
          "official": true,
          "published_at": "2026-07-22T10:00:00.000Z"
        }
        """#.data(using: .utf8)!

        let dto = try JSONDecoder().decode(TMDBMovieTrailerDTO.self, from: data)

        #expect(dto.id == "video-id")
        #expect(dto.key == "youtube-key")
        #expect(dto.site == "YouTube")
        #expect(dto.type == "Trailer")
        #expect(dto.official == true)
        #expect(dto.publishedAt == "2026-07-22T10:00:00.000Z")
    }
}
