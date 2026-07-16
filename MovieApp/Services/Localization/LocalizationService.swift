//
//  LocalizationService.swift
//  MovieApp
//
//  Created by Ivan P. on 16/07/2026.
//

import Foundation

// MARK: - Localization Contract

/// A common interface for localized text.
///
/// Use this protocol when a class needs text from `.xcstrings` files.
protocol LocalizationServiceProtocol {
    /// Returns localized text for a key.
    ///
    /// - Parameters:
    ///   - key: The string key from a string catalog.
    ///   - table: The string catalog table name.
    ///   - value: The fallback value if the key is missing.
    func localizedString(
        forKey key: String,
        table: String?,
        value: String
    ) -> String
}

// MARK: - Localization Service

/// Default localization service for the app.
final class LocalizationService: LocalizationServiceProtocol {
    static let shared = LocalizationService()

    private let bundle: Bundle

    // MARK: - Init

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    // MARK: - Public Methods

    /// Returns localized text from a string catalog table.
    func localizedString(
        forKey key: String,
        table: String?,
        value: String = ""
    ) -> String {
        NSLocalizedString(
            key,
            tableName: table,
            bundle: bundle,
            value: value.isEmpty ? key : value,
            comment: ""
        )
    }
}
