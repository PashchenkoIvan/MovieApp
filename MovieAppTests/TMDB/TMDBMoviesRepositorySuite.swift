//
//  TMDBMoviesRepositorySuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 22/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("TMDBMoviesRepository")
struct TMDBMoviesRepositorySuite {
    @Test("Load home movies maps DTOs and uses default TMDB parameters")
    func loadHomeMoviesMapsDTOsAndUsesDefaultTMDBParameters() async throws {
        let api = TMDBMoviesAPISpy()
        api.popularResult = .success([
            .fixture(id: 1, title: " Featured "),
            .fixture(id: nil, title: "Missing ID"),
            .fixture(id: 2, title: "   ", voteAverage: nil, popularity: nil)
        ])
        api.topRatedResult = .success([.fixture(id: 3, title: "Top Rated")])
        api.upcomingResult = .success([.fixture(id: 4, title: "Upcoming")])
        api.trailerResultsByMovieID = [
            1: .success([.youtube(id: "video-1", key: "official-1", official: true)]),
            2: .success([]),
            3: .success([]),
            4: .success([])
        ]
        let repository = TMDBMoviesRepository(moviesAPI: api)

        let homeMovies = try await repository.loadHomeMovies()

        let featured = try #require(homeMovies.featured)
        #expect(featured.id == 1)
        #expect(featured.title == "Featured")
        #expect(homeMovies.popular.map(\.id) == [2])
        #expect(homeMovies.popular.first?.title == "Untitled")
        #expect(homeMovies.popular.first?.voteAverage == 0)
        #expect(homeMovies.popular.first?.popularity == 0)
        #expect(homeMovies.topRated.map(\.id) == [3])
        #expect(homeMovies.upcoming.map(\.id) == [4])
        #expect(homeMovies.trailers.map(\.key) == ["official-1"])

        #expect(api.popularRequests == [MovieListRequest(language: "en-US", page: 1, region: "US")])
        #expect(api.topRatedRequests == [MovieListRequest(language: "en-US", page: 1, region: "US")])
        #expect(api.upcomingRequests == [MovieListRequest(language: "en-US", page: 1, region: "US")])
    }

    @Test("Trailer candidates are deduplicated and limited")
    func trailerCandidatesAreDeduplicatedAndLimited() async throws {
        let api = TMDBMoviesAPISpy()
        api.popularResult = .success((1...10).map { movieID -> TMDBMovieSummaryDTO in
            .fixture(id: movieID, title: "Movie")
        })
        api.topRatedResult = .success((1...3).map { movieID -> TMDBMovieSummaryDTO in
            .fixture(id: movieID, title: "Duplicate")
        })
        api.upcomingResult = .success([.fixture(id: 11, title: "Outside Limit")])
        api.trailerResultsByMovieID = Dictionary(
            uniqueKeysWithValues: (1...8).map { id in
                (id, .success([.youtube(id: "video-\(id)", key: "key-\(id)", official: true)]))
            }
        )
        let repository = TMDBMoviesRepository(moviesAPI: api)

        let homeMovies = try await repository.loadHomeMovies()

        #expect(api.movieTrailerRequests.map(\.movieID) == Array(1...8))
        #expect(homeMovies.trailers.map(\.movieID) == Array(1...8))
    }

    @Test("Best trailer prefers official YouTube trailer")
    func bestTrailerPrefersOfficialYouTubeTrailer() async throws {
        let api = TMDBMoviesAPISpy()
        api.popularResult = .success([.fixture(id: 42, title: "Feature")])
        api.topRatedResult = .success([])
        api.upcomingResult = .success([])
        api.trailerResultsByMovieID = [
            42: .success([
                .fixture(id: "vimeo", key: "vimeo-key", site: "Vimeo", type: "Trailer", official: true),
                .youtube(id: "teaser", key: "teaser-key", type: "Teaser", official: true),
                .youtube(id: "trailer", key: "trailer-key", type: "Trailer", official: false),
                .youtube(id: "official", key: "official-key", type: "Trailer", official: true)
            ])
        ]
        let repository = TMDBMoviesRepository(moviesAPI: api)

        let homeMovies = try await repository.loadHomeMovies()

        let trailer = try #require(homeMovies.trailers.first)
        #expect(trailer.id == "official")
        #expect(trailer.movieID == 42)
        #expect(trailer.movieTitle == "Feature")
        #expect(trailer.name == "Official Trailer")
        #expect(trailer.key == "official-key")
        #expect(trailer.isOfficial == true)
    }

    @Test("Trailer failures are skipped without failing home movies")
    func trailerFailuresAreSkippedWithoutFailingHomeMovies() async throws {
        let api = TMDBMoviesAPISpy()
        api.popularResult = .success([
            .fixture(id: 1, title: "Broken Trailer"),
            .fixture(id: 2, title: "No Trailer"),
            .fixture(id: 3, title: "Working Trailer")
        ])
        api.topRatedResult = .success([])
        api.upcomingResult = .success([])
        api.trailerResultsByMovieID = [
            1: .failure(TMDBMoviesRepositoryTestError.trailerFailed),
            2: .success([]),
            3: .success([.youtube(id: nil, name: "", key: "working-key", type: nil, official: nil)])
        ]
        let repository = TMDBMoviesRepository(moviesAPI: api)

        let homeMovies = try await repository.loadHomeMovies()

        let trailer = try #require(homeMovies.trailers.first)
        #expect(homeMovies.trailers.count == 1)
        #expect(trailer.id == "3-working-key")
        #expect(trailer.name == "Trailer")
        #expect(trailer.type == "Trailer")
        #expect(trailer.isOfficial == false)
    }

    @Test("Movie list failures are propagated")
    func movieListFailuresArePropagated() async throws {
        let api = TMDBMoviesAPISpy()
        api.popularResult = .failure(TMDBMoviesRepositoryTestError.listFailed)
        api.topRatedResult = .success([])
        api.upcomingResult = .success([])
        let repository = TMDBMoviesRepository(moviesAPI: api)

        do {
            _ = try await repository.loadHomeMovies()
            Issue.record("Expected list failure")
        } catch TMDBMoviesRepositoryTestError.listFailed {
            #expect(true)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private final class TMDBMoviesAPISpy: TMDBMoviesAPIProtocol, @unchecked Sendable {
    var popularResult: Result<[TMDBMovieSummaryDTO], Error> = .success([])
    var topRatedResult: Result<[TMDBMovieSummaryDTO], Error> = .success([])
    var upcomingResult: Result<[TMDBMovieSummaryDTO], Error> = .success([])
    var trailerResultsByMovieID: [Int: Result<[TMDBMovieTrailerDTO], Error>] = [:]

    private let lock = NSLock()
    private var storedPopularRequests: [MovieListRequest] = []
    private var storedTopRatedRequests: [MovieListRequest] = []
    private var storedUpcomingRequests: [MovieListRequest] = []
    private var storedMovieTrailerRequests: [MovieTrailerRequest] = []

    var popularRequests: [MovieListRequest] {
        lock.withLock { storedPopularRequests }
    }

    var topRatedRequests: [MovieListRequest] {
        lock.withLock { storedTopRatedRequests }
    }

    var upcomingRequests: [MovieListRequest] {
        lock.withLock { storedUpcomingRequests }
    }

    var movieTrailerRequests: [MovieTrailerRequest] {
        lock.withLock { storedMovieTrailerRequests }
    }

    func popularMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO] {
        lock.withLock {
            storedPopularRequests.append(MovieListRequest(language: language, page: page, region: region))
        }
        return try popularResult.get()
    }

    func topRatedMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO] {
        lock.withLock {
            storedTopRatedRequests.append(MovieListRequest(language: language, page: page, region: region))
        }
        return try topRatedResult.get()
    }

    func upcomingMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO] {
        lock.withLock {
            storedUpcomingRequests.append(MovieListRequest(language: language, page: page, region: region))
        }
        return try upcomingResult.get()
    }

    func movieTrailers(movieID: Int, language: String?) async throws -> [TMDBMovieTrailerDTO] {
        lock.withLock {
            storedMovieTrailerRequests.append(MovieTrailerRequest(movieID: movieID, language: language))
        }
        return try trailerResultsByMovieID[movieID, default: .success([])].get()
    }
}

private struct MovieListRequest: Equatable {
    let language: String?
    let page: Int?
    let region: String?
}

private struct MovieTrailerRequest: Equatable {
    let movieID: Int
    let language: String?
}

private enum TMDBMoviesRepositoryTestError: Error {
    case listFailed
    case trailerFailed
}

private extension TMDBMovieSummaryDTO {
    static func fixture(
        id: Int?,
        title: String,
        voteAverage: Double? = 7.2,
        popularity: Double? = 42
    ) -> TMDBMovieSummaryDTO {
        TMDBMovieSummaryDTO(
            id: id,
            title: title,
            overview: "Overview",
            posterPath: "/poster-\(id.map(String.init) ?? "missing").jpg",
            backdropPath: "/backdrop-\(id.map(String.init) ?? "missing").jpg",
            releaseDate: "2026-07-22",
            voteAverage: voteAverage,
            popularity: popularity
        )
    }
}

private extension TMDBMovieTrailerDTO {
    static func youtube(
        id: String?,
        name: String = "Official Trailer",
        key: String,
        type: String? = "Trailer",
        official: Bool? = true
    ) -> TMDBMovieTrailerDTO {
        fixture(id: id, name: name, key: key, site: "YouTube", type: type, official: official)
    }

    static func fixture(
        id: String?,
        name: String = "Official Trailer",
        key: String,
        site: String?,
        type: String?,
        official: Bool?
    ) -> TMDBMovieTrailerDTO {
        TMDBMovieTrailerDTO(
            id: id,
            name: name,
            key: key,
            site: site,
            type: type,
            official: official,
            publishedAt: "2026-07-22T10:00:00.000Z"
        )
    }
}
