//
//  TMDBMoviesAPI.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

protocol TMDBMoviesAPIProtocol {
    func popularMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO]
    func topRatedMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO]
    func upcomingMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO]
    func movieTrailers(movieID: Int, language: String?) async throws -> [TMDBMovieTrailerDTO]
}

final class TMDBMoviesAPI: TMDBMoviesAPIProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func popularMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO] {
        let endpoint = Endpoint.tmdbMoviePopularList(language: language, page: page, region: region)
        let response: TMDBMovieListResponseDTO = try await networkClient.request(endpoint)
        return response.results ?? []
    }

    func topRatedMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO] {
        let endpoint = Endpoint.tmdbMovieTopRatedList(language: language, page: page, region: region)
        let response: TMDBMovieListResponseDTO = try await networkClient.request(endpoint)
        return response.results ?? []
    }

    func upcomingMovies(language: String?, page: Int?, region: String?) async throws -> [TMDBMovieSummaryDTO] {
        let endpoint = Endpoint.tmdbMovieUpcomingList(language: language, page: page, region: region)
        let response: TMDBMovieListResponseDTO = try await networkClient.request(endpoint)
        return response.results ?? []
    }

    func movieTrailers(movieID: Int, language: String?) async throws -> [TMDBMovieTrailerDTO] {
        let endpoint = Endpoint.tmdbMovieVideos(movieId: movieID, language: language)
        let response: TMDBMovieTrailersResponseDTO = try await networkClient.request(endpoint)
        return response.results ?? []
    }
}

struct TMDBMovieListResponseDTO: Decodable, Equatable, Sendable {
    let results: [TMDBMovieSummaryDTO]?
}

struct TMDBMovieTrailersResponseDTO: Decodable, Equatable, Sendable {
    let results: [TMDBMovieTrailerDTO]?
}
