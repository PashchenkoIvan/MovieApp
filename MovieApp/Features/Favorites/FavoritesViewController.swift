//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import UIKit

final class FavoritesViewController: TabPlaceholderViewController {
    init(localizationService: LocalizationServiceProtocol = LocalizationService.shared) {
        super.init(configuration: TabPlaceholderConfiguration(
            iconName: "heart.fill",
            title: localizationService.localizedString(forKey: "favorites.title", table: Screens.main.localizationTable, value: "Favorites"),
            subtitle: localizationService.localizedString(forKey: "favorites.subtitle", table: Screens.main.localizationTable, value: "A quiet library for movies worth keeping."),
            accentColor: .systemPink,
            highlights: [
                TabPlaceholderHighlight(
                    iconName: "checkmark.seal.fill",
                    title: localizationService.localizedString(forKey: "favorites.highlight.saved.title", table: Screens.main.localizationTable, value: "Saved Locally"),
                    subtitle: localizationService.localizedString(forKey: "favorites.highlight.saved.subtitle", table: Screens.main.localizationTable, value: "Favorite movies are stored on this device.")
                ),
                TabPlaceholderHighlight(
                    iconName: "arrow.triangle.2.circlepath",
                    title: localizationService.localizedString(forKey: "favorites.highlight.sync.title", table: Screens.main.localizationTable, value: "Ready to Sync"),
                    subtitle: localizationService.localizedString(forKey: "favorites.highlight.sync.subtitle", table: Screens.main.localizationTable, value: "The screen is prepared for TMDB account lists later.")
                ),
                TabPlaceholderHighlight(
                    iconName: "text.badge.checkmark",
                    title: localizationService.localizedString(forKey: "favorites.highlight.organized.title", table: Screens.main.localizationTable, value: "Organized"),
                    subtitle: localizationService.localizedString(forKey: "favorites.highlight.organized.subtitle", table: Screens.main.localizationTable, value: "Saved titles will remain easy to scan and compare.")
                )
            ]
        ))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
