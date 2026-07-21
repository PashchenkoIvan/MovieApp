//
//  FavoriteMoviesLocalDataSourceSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("FavoriteMoviesLocalDataSource")
struct FavoriteMoviesLocalDataSourceSuite {
    @Test("Fetch favorites returns saved movies sorted by newest first")
    func fetchFavoritesReturnsSavedMoviesSortedByNewestFirst() throws {
        let dataSource = try makeDataSource()
        let older = makeFavorite(movieID: 1, title: "Older", createdAt: Date(timeIntervalSince1970: 100))
        let newer = makeFavorite(movieID: 2, title: "Newer", createdAt: Date(timeIntervalSince1970: 200))

        try dataSource.saveFavorite(older)
        try dataSource.saveFavorite(newer)

        let favorites = try dataSource.fetchFavorites()
        #expect(favorites == [newer, older])
    }

    @Test("Save favorite replaces existing movie with same id")
    func saveFavoriteReplacesExistingMovieWithSameID() throws {
        let dataSource = try makeDataSource()
        let original = makeFavorite(movieID: 1, title: "Original")
        let replacement = makeFavorite(movieID: 1, title: "Replacement", voteAverage: 9.1)

        try dataSource.saveFavorite(original)
        try dataSource.saveFavorite(replacement)

        let favorites = try dataSource.fetchFavorites()
        #expect(favorites == [replacement])
    }

    @Test("Is favorite returns true for saved movie")
    func isFavoriteReturnsTrueForSavedMovie() throws {
        let dataSource = try makeDataSource()
        try dataSource.saveFavorite(makeFavorite(movieID: 1, title: "Movie"))

        #expect(try dataSource.isFavorite(movieID: 1) == true)
    }

    @Test("Is favorite returns false for missing movie")
    func isFavoriteReturnsFalseForMissingMovie() throws {
        let dataSource = try makeDataSource()

        #expect(try dataSource.isFavorite(movieID: 999) == false)
    }

    @Test("Delete favorite removes only matching movie")
    func deleteFavoriteRemovesOnlyMatchingMovie() throws {
        let dataSource = try makeDataSource()
        let first = makeFavorite(movieID: 1, title: "First")
        let second = makeFavorite(movieID: 2, title: "Second")
        try dataSource.saveFavorite(first)
        try dataSource.saveFavorite(second)

        try dataSource.deleteFavorite(movieID: 1)

        #expect(try dataSource.fetchFavorites() == [second])
        #expect(try dataSource.isFavorite(movieID: 1) == false)
        #expect(try dataSource.isFavorite(movieID: 2) == true)
    }

    @Test("Delete missing favorite does not remove other movies")
    func deleteMissingFavoriteDoesNotRemoveOtherMovies() throws {
        let dataSource = try makeDataSource()
        let movie = makeFavorite(movieID: 1, title: "Movie")
        try dataSource.saveFavorite(movie)

        try dataSource.deleteFavorite(movieID: 999)

        #expect(try dataSource.fetchFavorites() == [movie])
    }

    @Test("Delete all favorites removes all movies")
    func deleteAllFavoritesRemovesAllMovies() throws {
        let dataSource = try makeDataSource()
        try dataSource.saveFavorite(makeFavorite(movieID: 1, title: "First"))
        try dataSource.saveFavorite(makeFavorite(movieID: 2, title: "Second"))

        try dataSource.deleteAllFavorites()

        #expect(try dataSource.fetchFavorites().isEmpty)
    }
}

private func makeDataSource() throws -> FavoriteMoviesLocalDataSource {
    FavoriteMoviesLocalDataSource(storage: try SwiftDataStorage(inMemory: true))
}

private func makeFavorite(
    movieID: Int,
    title: String,
    posterPath: String? = "/poster.jpg",
    overview: String = "Overview",
    releaseDate: String? = "2026-07-21",
    voteAverage: Double = 8.5,
    createdAt: Date = Date(timeIntervalSince1970: 100)
) -> FavoriteMovie {
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
