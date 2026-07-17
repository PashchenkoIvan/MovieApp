//
//  AuthSessionKeychainDataSource.swift
//  MovieApp
//
//  Created by Ivan P. on 16/07/2026.
//

import Foundation

// MARK: - Auth Session Keychain Data Source

/// CRUD service for auth session in Keychain.
final class AuthSessionKeychainDataSource {
    private enum Key {
        static let sessionID = "auth.sessionID"
    }

    private let keychainStorage: KeychainStorage

    // MARK: - Init

    init(keychainStorage: KeychainStorage) {
        self.keychainStorage = keychainStorage
    }

    // MARK: - Public Methods

    /// Saves current auth session.
    func saveSession(_ session: AuthSession) throws {
        try keychainStorage.save(session.sessionID, forKey: Key.sessionID)
    }

    /// Returns current auth session if it exists.
    func getSession() throws -> AuthSession? {
        guard let sessionID = try keychainStorage.read(forKey: Key.sessionID) else {
            return nil
        }

        return AuthSession(sessionID: sessionID)
    }

    /// Deletes current auth session.
    func deleteSession() throws {
        try keychainStorage.delete(forKey: Key.sessionID)
    }
}
