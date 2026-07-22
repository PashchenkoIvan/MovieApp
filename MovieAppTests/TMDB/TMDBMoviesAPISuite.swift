//
//  TMDBMoviesAPISuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 22/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("TMDBMoviesAPI")
struct TMDBMoviesAPISuite {
    @Test("Popular movies builds endpoint and returns decoded results")
    func popularMoviesBuildsEndpointAndReturnsDecodedResults() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .success(TMDBMovieListResponseDTO(results: [.fixture()]))
        let api = TMDBMoviesAPI(networkClient: networkClient)

        let movies = try await api.popularMovies(language: "en-US", page: 2, region: "US")

        let endpoint = try #require(networkClient.receivedEndpoints.first)
        #expect(endpoint.path == "/movie/popular")
        #expect(endpoint.method == .get)
        #expect(queryValue("language", in: endpoint) == "en-US")
        #expect(queryValue("page", in: endpoint) == "2")
        #expect(queryValue("region", in: endpoint) == "US")
        #expect(movies.count == 1)
        #expect(movies.first?.title == "Feature")
        #expect(movies.first?.voteAverage == 7.8)
    }

    @Test("Top rated movies builds endpoint")
    func topRatedMoviesBuildsEndpoint() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .success(TMDBMovieListResponseDTO(results: []))
        let api = TMDBMoviesAPI(networkClient: networkClient)

        let movies = try await api.topRatedMovies(language: "uk-UA", page: 3, region: nil)

        let endpoint = try #require(networkClient.receivedEndpoints.first)
        #expect(endpoint.path == "/movie/top_rated")
        #expect(endpoint.method == .get)
        #expect(queryValue("language", in: endpoint) == "uk-UA")
        #expect(queryValue("page", in: endpoint) == "3")
        #expect(queryValue("region", in: endpoint) == nil)
        #expect(movies.isEmpty)
    }

    @Test("Upcoming movies builds endpoint")
    func upcomingMoviesBuildsEndpoint() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .success(TMDBMovieListResponseDTO(results: []))
        let api = TMDBMoviesAPI(networkClient: networkClient)

        let movies = try await api.upcomingMovies(language: nil, page: nil, region: "PL")

        let endpoint = try #require(networkClient.receivedEndpoints.first)
        #expect(endpoint.path == "/movie/upcoming")
        #expect(endpoint.method == .get)
        #expect(queryValue("language", in: endpoint) == nil)
        #expect(queryValue("page", in: endpoint) == nil)
        #expect(queryValue("region", in: endpoint) == "PL")
        #expect(movies.isEmpty)
    }

    @Test("Movie trailers builds endpoint and returns decoded results")
    func movieTrailersBuildsEndpointAndReturnsDecodedResults() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .success(TMDBMovieTrailersResponseDTO(results: [.trailerFixture()]))
        let api = TMDBMoviesAPI(networkClient: networkClient)

        let trailers = try await api.movieTrailers(movieID: 42, language: "en-US")

        let endpoint = try #require(networkClient.receivedEndpoints.first)
        #expect(endpoint.path == "/movie/42/videos")
        #expect(endpoint.method == .get)
        #expect(queryValue("language", in: endpoint) == "en-US")
        #expect(trailers.count == 1)
        #expect(trailers.first?.key == "youtube-key")
        #expect(trailers.first?.publishedAt == "2026-07-22T10:00:00.000Z")
    }

    @Test("Nil results decode as empty arrays")
    func nilResultsDecodeAsEmptyArrays() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .success(TMDBMovieListResponseDTO(results: nil))
        let api = TMDBMoviesAPI(networkClient: networkClient)

        let movies = try await api.popularMovies(language: nil, page: nil, region: nil)

        #expect(movies.isEmpty)
    }

    @Test("Network errors are propagated")
    func networkErrorsArePropagated() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .failure(APIError.invalidResponse)
        let api = TMDBMoviesAPI(networkClient: networkClient)

        do {
            _ = try await api.popularMovies(language: nil, page: nil, region: nil)
            Issue.record("Expected network error")
        } catch APIError.invalidResponse {
            #expect(true)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private func queryValue(_ name: String, in endpoint: Endpoint) -> String? {
    endpoint.queryItems.first { $0.name == name }?.value
}

private extension TMDBMovieSummaryDTO {
    static func fixture() -> TMDBMovieSummaryDTO {
        TMDBMovieSummaryDTO(
            id: 42,
            title: "Feature",
            overview: "Overview",
            posterPath: "/poster.jpg",
            backdropPath: "/backdrop.jpg",
            releaseDate: "2026-07-22",
            voteAverage: 7.8,
            popularity: 99.5
        )
    }
}

private extension TMDBMovieTrailerDTO {
    static func trailerFixture() -> TMDBMovieTrailerDTO {
        TMDBMovieTrailerDTO(
            id: "video-id",
            name: "Official Trailer",
            key: "youtube-key",
            site: "YouTube",
            type: "Trailer",
            official: true,
            publishedAt: "2026-07-22T10:00:00.000Z"
        )
    }
}
