//
//  FavoriteMoviesLocalDataSource.swift
//  MovieApp
//
//  Created by Ivan P. on 16/07/2026.
//

import Foundation
import SwiftData

// MARK: - Favorite Movies Local Data Source

/// CRUD service for favorite movies in local SwiftData storage.
final class FavoriteMoviesLocalDataSource {
    private let storage: SwiftDataStorage

    // MARK: - Init

    init(storage: SwiftDataStorage) {
        self.storage = storage
    }

    // MARK: - Public Methods

    /// Saves a movie as favorite. If it already exists, it replaces old data.
    func saveFavorite(_ movie: FavoriteMovie) throws {
        let context = storage.makeContext()
        try deleteFavorite(movieID: movie.movieID, in: context)

        context.insert(FavoriteMovieEntity(movie: movie))
        try storage.save(context)
    }

    /// Returns all favorite movies sorted by creation date.
    func fetchFavorites() throws -> [FavoriteMovie] {
        let descriptor = FetchDescriptor<FavoriteMovieEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        return try storage.fetch(descriptor).map { $0.toDomain() }
    }

    /// Checks if movie is already favorite.
    func isFavorite(movieID: Int) throws -> Bool {
        var descriptor = FetchDescriptor<FavoriteMovieEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        descriptor.fetchLimit = 1

        return try !storage.fetch(descriptor).isEmpty
    }

    /// Deletes one favorite movie by TMDB movie id.
    func deleteFavorite(movieID: Int) throws {
        let context = storage.makeContext()
        try deleteFavorite(movieID: movieID, in: context)
        try storage.save(context)
    }

    /// Deletes all favorite movies.
    func deleteAllFavorites() throws {
        let descriptor = FetchDescriptor<FavoriteMovieEntity>()
        try storage.deleteAll(descriptor)
    }
}

// MARK: - Private Helpers

private extension FavoriteMoviesLocalDataSource {
    func deleteFavorite(movieID: Int, in context: ModelContext) throws {
        var descriptor = FetchDescriptor<FavoriteMovieEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        descriptor.fetchLimit = 1

        let movies = try context.fetch(descriptor)
        movies.forEach { context.delete($0) }
    }
}

// MARK: - Mapping

private extension FavoriteMovieEntity {
    convenience init(movie: FavoriteMovie) {
        self.init(
            movieID: movie.movieID,
            title: movie.title,
            posterPath: movie.posterPath,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            voteAverage: movie.voteAverage,
            createdAt: movie.createdAt
        )
    }

    func toDomain() -> FavoriteMovie {
        FavoriteMovie(
            movieID: movieID,
            title: title,
            posterPath: posterPath,
            overview: overview,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            createdAt: createdAt
        )
    }
}
