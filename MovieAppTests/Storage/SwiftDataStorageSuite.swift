//
//  SwiftDataStorageSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import SwiftData
import Testing

@testable import MovieApp

@MainActor
@Suite("SwiftDataStorage")
struct SwiftDataStorageSuite {
    @Test("Insert saves model")
    func insertSavesModel() throws {
        let storage = try SwiftDataStorage(inMemory: true)
        let movie = makeEntity(movieID: 1, title: "First")

        try storage.insert(movie)

        let movies = try storage.fetch(FetchDescriptor<FavoriteMovieEntity>())
        #expect(movies.count == 1)
        #expect(movies.first?.movieID == 1)
        #expect(movies.first?.title == "First")
    }

    @Test("Fetch returns descriptor results")
    func fetchReturnsDescriptorResults() throws {
        let storage = try SwiftDataStorage(inMemory: true)
        try storage.insert(makeEntity(movieID: 1, title: "First"))
        try storage.insert(makeEntity(movieID: 2, title: "Second"))

        let descriptor = FetchDescriptor<FavoriteMovieEntity>(
            predicate: #Predicate { $0.movieID == 2 }
        )

        let movies = try storage.fetch(descriptor)
        #expect(movies.map(\.movieID) == [2])
    }

    @Test("Delete all removes matching models")
    func deleteAllRemovesMatchingModels() throws {
        let storage = try SwiftDataStorage(inMemory: true)
        try storage.insert(makeEntity(movieID: 1, title: "First"))
        try storage.insert(makeEntity(movieID: 2, title: "Second"))

        let descriptor = FetchDescriptor<FavoriteMovieEntity>(
            predicate: #Predicate { $0.movieID == 1 }
        )
        try storage.deleteAll(descriptor)

        let movies = try storage.fetch(FetchDescriptor<FavoriteMovieEntity>())
        #expect(movies.map(\.movieID) == [2])
    }

    @Test("Save without changes is no op")
    func saveWithoutChangesIsNoOp() throws {
        let storage = try SwiftDataStorage(inMemory: true)
        let context = storage.makeContext()

        try storage.save(context)

        #expect(context.hasChanges == false)
    }
}

private func makeEntity(
    movieID: Int,
    title: String,
    createdAt: Date = Date()
) -> FavoriteMovieEntity {
    FavoriteMovieEntity(
        movieID: movieID,
        title: title,
        posterPath: "/poster.jpg",
        overview: "Overview",
        releaseDate: "2026-07-21",
        voteAverage: 8.5,
        createdAt: createdAt
    )
}
