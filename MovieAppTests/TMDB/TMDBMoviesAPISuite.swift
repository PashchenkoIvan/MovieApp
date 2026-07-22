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
@Suite("TMDBMoviesAPI", .serialized)
struct TMDBMoviesAPISuite {
    init() {
        URLProtocolMock.reset()
    }

    @Test("Popular movies builds endpoint and returns decoded results")
    func popularMoviesBuildsEndpointAndReturnsDecodedResults() async throws {
        let api = makeAPI()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(movieListJSON.utf8))
        }

        let movies = try await api.popularMovies(language: "en-US", page: 2, region: "US")

        let request = try #require(URLProtocolMock.receivedRequests.first)
        let components = try #require(URLComponents(url: try #require(request.url), resolvingAgainstBaseURL: false))
        #expect(components.path == "/3/movie/popular")
        #expect(queryValue("language", in: components) == "en-US")
        #expect(queryValue("page", in: components) == "2")
        #expect(queryValue("region", in: components) == "US")
        #expect(movies.count == 1)
        #expect(movies.first?.title == "Feature")
        #expect(movies.first?.voteAverage == 7.8)
    }

    @Test("Top rated movies builds endpoint")
    func topRatedMoviesBuildsEndpoint() async throws {
        let api = makeAPI()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{"results":[]}"#.utf8))
        }

        let movies = try await api.topRatedMovies(language: "uk-UA", page: 3, region: nil)

        let request = try #require(URLProtocolMock.receivedRequests.first)
        let components = try #require(URLComponents(url: try #require(request.url), resolvingAgainstBaseURL: false))
        #expect(components.path == "/3/movie/top_rated")
        #expect(queryValue("language", in: components) == "uk-UA")
        #expect(queryValue("page", in: components) == "3")
        #expect(queryValue("region", in: components) == nil)
        #expect(movies.isEmpty)
    }

    @Test("Upcoming movies builds endpoint")
    func upcomingMoviesBuildsEndpoint() async throws {
        let api = makeAPI()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{"results":[]}"#.utf8))
        }

        let movies = try await api.upcomingMovies(language: nil, page: nil, region: "PL")

        let request = try #require(URLProtocolMock.receivedRequests.first)
        let components = try #require(URLComponents(url: try #require(request.url), resolvingAgainstBaseURL: false))
        #expect(components.path == "/3/movie/upcoming")
        #expect(queryValue("language", in: components) == nil)
        #expect(queryValue("page", in: components) == nil)
        #expect(queryValue("region", in: components) == "PL")
        #expect(movies.isEmpty)
    }

    @Test("Movie trailers builds endpoint and returns decoded results")
    func movieTrailersBuildsEndpointAndReturnsDecodedResults() async throws {
        let api = makeAPI()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(trailerListJSON.utf8))
        }

        let trailers = try await api.movieTrailers(movieID: 42, language: "en-US")

        let request = try #require(URLProtocolMock.receivedRequests.first)
        let components = try #require(URLComponents(url: try #require(request.url), resolvingAgainstBaseURL: false))
        #expect(components.path == "/3/movie/42/videos")
        #expect(queryValue("language", in: components) == "en-US")
        #expect(trailers.count == 1)
        #expect(trailers.first?.key == "youtube-key")
        #expect(trailers.first?.publishedAt == "2026-07-22T10:00:00.000Z")
    }

    @Test("Nil results decode as empty arrays")
    func nilResultsDecodeAsEmptyArrays() async throws {
        let api = makeAPI()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{}"#.utf8))
        }

        let movies = try await api.popularMovies(language: nil, page: nil, region: nil)

        #expect(movies.isEmpty)
    }

    @Test("Network errors are propagated")
    func networkErrorsArePropagated() async throws {
        let api = makeAPI()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 500)
            return (response, Data())
        }

        do {
            _ = try await api.popularMovies(language: nil, page: nil, region: nil)
            Issue.record("Expected HTTP status code error")
        } catch APIError.httpStatusCode(let statusCode, _) {
            #expect(statusCode == 500)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private extension TMDBMoviesAPISuite {
    func makeAPI() -> TMDBMoviesAPI {
        URLProtocolMock.reset()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]

        let networkClient = NetworkClient(
            configuration: TMDBConfiguration(
                baseURL: URL(string: "https://api.test.themoviedb.org/3")!,
                readAccessToken: "token"
            ),
            session: URLSession(configuration: configuration)
        )

        return TMDBMoviesAPI(networkClient: networkClient)
    }
}

private func queryValue(_ name: String, in components: URLComponents) -> String? {
    components.queryItems?.first { $0.name == name }?.value
}

private let movieListJSON = #"""
{
  "results": [
    {
      "id": 42,
      "title": "Feature",
      "overview": "Overview",
      "poster_path": "/poster.jpg",
      "backdrop_path": "/backdrop.jpg",
      "release_date": "2026-07-22",
      "vote_average": 7.8,
      "popularity": 99.5
    }
  ]
}
"""#

private let trailerListJSON = #"""
{
  "results": [
    {
      "id": "video-id",
      "name": "Official Trailer",
      "key": "youtube-key",
      "site": "YouTube",
      "type": "Trailer",
      "official": true,
      "published_at": "2026-07-22T10:00:00.000Z"
    }
  ]
}
"""#

private func makeURL(for request: URLRequest) throws -> URL {
    guard let url = request.url else {
        throw URLError(.badURL)
    }
    return url
}

private func makeHTTPResponse(
    for request: URLRequest,
    statusCode: Int
) throws -> HTTPURLResponse {
    guard let response = HTTPURLResponse(
        url: try makeURL(for: request),
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil
    ) else {
        throw URLError(.badServerResponse)
    }
    return response
}
