//
//  TMDBMoviesRepository.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

final class TMDBMoviesRepository: MoviesRepository {
    private enum Defaults {
        static let language = "en-US"
        static let region = "US"
        static let page = 1
        static let trailerLimit = 8
    }

    private let moviesAPI: TMDBMoviesAPIProtocol

    init(moviesAPI: TMDBMoviesAPIProtocol) {
        self.moviesAPI = moviesAPI
    }

    func loadHomeMovies() async throws -> HomeMovies {
        async let popularDTOs = moviesAPI.popularMovies(language: Defaults.language, page: Defaults.page, region: Defaults.region)
        async let topRatedDTOs = moviesAPI.topRatedMovies(language: Defaults.language, page: Defaults.page, region: Defaults.region)
        async let upcomingDTOs = moviesAPI.upcomingMovies(language: Defaults.language, page: Defaults.page, region: Defaults.region)

        let popular = try await popularDTOs.compactMap(Movie.init(dto:))
        let topRated = try await topRatedDTOs.compactMap(Movie.init(dto:))
        let upcoming = try await upcomingDTOs.compactMap(Movie.init(dto:))
        let featured = popular.first
        let trailers = await loadTrailers(for: trailerCandidates(featured: featured, popular: popular, topRated: topRated, upcoming: upcoming))

        return HomeMovies(
            featured: featured,
            trailers: trailers,
            popular: Array(popular.dropFirst()),
            topRated: topRated,
            upcoming: upcoming
        )
    }
}

private extension TMDBMoviesRepository {
    func trailerCandidates(
        featured: Movie?,
        popular: [Movie],
        topRated: [Movie],
        upcoming: [Movie]
    ) -> [Movie] {
        var seenIDs = Set<Int>()
        var candidates: [Movie] = []

        ([featured].compactMap { $0 } + popular + topRated + upcoming).forEach { movie in
            guard !seenIDs.contains(movie.id), candidates.count < Defaults.trailerLimit else { return }
            seenIDs.insert(movie.id)
            candidates.append(movie)
        }

        return candidates
    }

    func loadTrailers(for movies: [Movie]) async -> [MovieTrailer] {
        var trailers: [MovieTrailer] = []

        for movie in movies {
            guard let dto = try? await moviesAPI.movieTrailers(movieID: movie.id, language: Defaults.language).bestTrailer,
                  let trailer = MovieTrailer(movie: movie, dto: dto) else {
                continue
            }

            trailers.append(trailer)
        }

        return trailers
    }
}

private extension Array where Element == TMDBMovieTrailerDTO {
    var bestTrailer: TMDBMovieTrailerDTO? {
        let youtubeVideos = filter { $0.site?.caseInsensitiveCompare("YouTube") == .orderedSame && $0.key?.isEmpty == false }
        let officialTrailers = youtubeVideos.filter { $0.official == true && $0.type?.caseInsensitiveCompare("Trailer") == .orderedSame }
        let trailers = youtubeVideos.filter { $0.type?.caseInsensitiveCompare("Trailer") == .orderedSame }
        let teasers = youtubeVideos.filter { $0.type?.caseInsensitiveCompare("Teaser") == .orderedSame }

        return officialTrailers.first ?? trailers.first ?? teasers.first ?? youtubeVideos.first
    }
}

private extension MovieTrailer {
    init?(movie: Movie, dto: TMDBMovieTrailerDTO) {
        guard let key = dto.key, !key.isEmpty else { return nil }

        self.init(
            id: dto.id ?? "\(movie.id)-\(key)",
            movieID: movie.id,
            movieTitle: movie.title,
            name: dto.name?.isEmpty == false ? dto.name ?? "Trailer" : "Trailer",
            key: key,
            site: dto.site ?? "YouTube",
            type: dto.type ?? "Trailer",
            isOfficial: dto.official ?? false
        )
    }
}

private extension Movie {
    init?(dto: TMDBMovieSummaryDTO) {
        guard let id = dto.id else { return nil }

        let candidateTitle = dto.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        let title = candidateTitle?.isEmpty == false ? candidateTitle ?? "Untitled" : "Untitled"
        self.init(
            id: id,
            title: title,
            overview: dto.overview ?? "",
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            releaseDate: dto.releaseDate,
            voteAverage: dto.voteAverage ?? 0,
            popularity: dto.popularity ?? 0
        )
    }
}
