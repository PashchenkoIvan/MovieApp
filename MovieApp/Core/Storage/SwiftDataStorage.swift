//
//  SwiftDataStorage.swift
//  MovieApp
//
//  Created by Ivan P. on 16/07/2026.
//

import Foundation
import SwiftData

// MARK: - SwiftData Storage

/// Common SwiftData storage manager.
///
/// Use this class for normal local app data, for example favorites or cache.
/// Do not use it for secrets like auth session tokens.
final class SwiftDataStorage {
    private let container: ModelContainer
    private let logger = LogService()

    // MARK: - Init

    init(inMemory: Bool = false) throws {
        let schema = Schema([
            FavoriteMovieEntity.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )

        self.container = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )

        logger.log(
            "SwiftData storage initialized",
            level: .info,
            category: .app,
            metadata: ["inMemory": String(inMemory)]
        )
    }

    // MARK: - Context

    /// Creates a new context for storage work.
    func makeContext() -> ModelContext {
        ModelContext(container)
    }

    // MARK: - CRUD

    /// Inserts a new model and saves the context.
    func insert<T: PersistentModel>(_ model: T) throws {
        let context = makeContext()
        context.insert(model)
        try save(context)
    }

    /// Fetches models by descriptor.
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T] {
        let context = makeContext()
        return try context.fetch(descriptor)
    }

    /// Deletes all models that match the descriptor.
    func deleteAll<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws {
        let context = makeContext()
        let models = try context.fetch(descriptor)
        models.forEach { context.delete($0) }
        try save(context)
    }

    /// Saves context changes when needed.
    func save(_ context: ModelContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
