//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import UIKit

final class SearchViewController: TabPlaceholderViewController {
    init(localizationService: LocalizationServiceProtocol = LocalizationService.shared) {
        super.init(configuration: TabPlaceholderConfiguration(
            iconName: "magnifyingglass",
            title: localizationService.localizedString(forKey: "search.title", table: Screens.main.localizationTable, value: "Search"),
            subtitle: localizationService.localizedString(forKey: "search.subtitle", table: Screens.main.localizationTable, value: "Fast search across the TMDB catalog."),
            accentColor: .systemTeal,
            highlights: [
                TabPlaceholderHighlight(
                    iconName: "movieclapper.fill",
                    title: localizationService.localizedString(forKey: "search.highlight.movies.title", table: Screens.main.localizationTable, value: "Movies"),
                    subtitle: localizationService.localizedString(forKey: "search.highlight.movies.subtitle", table: Screens.main.localizationTable, value: "Find titles by name, year, and relevance.")
                ),
                TabPlaceholderHighlight(
                    iconName: "person.2.fill",
                    title: localizationService.localizedString(forKey: "search.highlight.people.title", table: Screens.main.localizationTable, value: "People"),
                    subtitle: localizationService.localizedString(forKey: "search.highlight.people.subtitle", table: Screens.main.localizationTable, value: "Cast and crew results stay close to movie context.")
                ),
                TabPlaceholderHighlight(
                    iconName: "rectangle.stack.fill",
                    title: localizationService.localizedString(forKey: "search.highlight.collections.title", table: Screens.main.localizationTable, value: "Collections"),
                    subtitle: localizationService.localizedString(forKey: "search.highlight.collections.subtitle", table: Screens.main.localizationTable, value: "Franchises and grouped stories in one place.")
                )
            ]
        ))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
