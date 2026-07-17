//
//  KeychainStorage.swift
//  MovieApp
//
//  Created by Ivan P. on 16/07/2026.
//

import Foundation
import Security

// MARK: - Keychain Error

/// Errors that can happen during Keychain work.
enum KeychainError: Error, LocalizedError {
    case unexpectedData
    case unhandledStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .unexpectedData:
            return "Keychain returned unexpected data."
        case .unhandledStatus(let status):
            return "Keychain failed with status: \(status)."
        }
    }
}

// MARK: - Keychain Storage

/// Secure storage for secret values like auth session id.
final class KeychainStorage {
    private let service: String

    // MARK: - Init

    init(service: String = Bundle.main.bundleIdentifier ?? "MovieApp") {
        self.service = service
    }

    // MARK: - Public Methods

    /// Saves or replaces string value by key.
    func save(_ value: String, forKey key: String) throws {
        let data = Data(value.utf8)
        let query = baseQuery(forKey: key)

        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data

        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledStatus(status)
        }
    }

    /// Reads string value by key.
    func read(forKey key: String) throws -> String? {
        var query = baseQuery(forKey: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.unhandledStatus(status)
        }

        guard
            let data = item as? Data,
            let value = String(data: data, encoding: .utf8)
        else {
            throw KeychainError.unexpectedData
        }

        return value
    }

    /// Deletes value by key.
    func delete(forKey key: String) throws {
        let status = SecItemDelete(baseQuery(forKey: key) as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledStatus(status)
        }
    }
}

// MARK: - Private Helpers

private extension KeychainStorage {
    func baseQuery(forKey key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }
}
