//
//  MovieDomainModelsSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 22/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@Suite("Movie domain models")
struct MovieDomainModelsSuite {
    @Test("Movie release year uses first date component")
    func movieReleaseYearUsesFirstDateComponent() {
        let movie = Movie(
            id: 1,
            title: "Feature",
            overview: "Overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2026-07-22",
            voteAverage: 7.8,
            popularity: 100
        )

        #expect(movie.releaseYear == "2026")
    }

    @Test("YouTube trailer exposes thumbnail and external URLs")
    func youtubeTrailerExposesThumbnailAndExternalURLs() {
        let trailer = MovieTrailer(
            id: "video-id",
            movieID: 42,
            movieTitle: "Feature",
            name: "Official Trailer",
            key: "youtube-key",
            site: "YouTube",
            type: "Trailer",
            isOfficial: true
        )

        #expect(trailer.thumbnailURL?.absoluteString == "https://img.youtube.com/vi/youtube-key/hqdefault.jpg")
        #expect(trailer.externalURL?.absoluteString == "https://www.youtube.com/watch?v=youtube-key")
    }

    @Test("Non YouTube trailer does not expose YouTube URLs")
    func nonYouTubeTrailerDoesNotExposeYouTubeURLs() {
        let trailer = MovieTrailer(
            id: "video-id",
            movieID: 42,
            movieTitle: "Feature",
            name: "Trailer",
            key: "video-key",
            site: "Vimeo",
            type: "Trailer",
            isOfficial: true
        )

        #expect(trailer.thumbnailURL == nil)
        #expect(trailer.externalURL == nil)
    }
}
