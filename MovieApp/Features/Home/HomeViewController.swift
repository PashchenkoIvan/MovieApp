//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import UIKit

final class HomeViewController: TabPlaceholderViewController {
    init(localizationService: LocalizationServiceProtocol = LocalizationService.shared) {
        super.init(configuration: TabPlaceholderConfiguration(
            iconName: "film.stack",
            title: localizationService.localizedString(forKey: "home.title", table: Screens.main.localizationTable, value: "Home"),
            subtitle: localizationService.localizedString(forKey: "home.subtitle", table: Screens.main.localizationTable, value: "A focused place for movie discovery."),
            accentColor: .systemIndigo,
            highlights: [
                TabPlaceholderHighlight(
                    iconName: "flame.fill",
                    title: localizationService.localizedString(forKey: "home.highlight.trending.title", table: Screens.main.localizationTable, value: "Trending"),
                    subtitle: localizationService.localizedString(forKey: "home.highlight.trending.subtitle", table: Screens.main.localizationTable, value: "Movies with current audience momentum.")
                ),
                TabPlaceholderHighlight(
                    iconName: "play.rectangle.fill",
                    title: localizationService.localizedString(forKey: "home.highlight.nowPlaying.title", table: Screens.main.localizationTable, value: "Now Playing"),
                    subtitle: localizationService.localizedString(forKey: "home.highlight.nowPlaying.subtitle", table: Screens.main.localizationTable, value: "Cinema releases and fresh catalog updates.")
                ),
                TabPlaceholderHighlight(
                    iconName: "star.fill",
                    title: localizationService.localizedString(forKey: "home.highlight.topRated.title", table: Screens.main.localizationTable, value: "Top Rated"),
                    subtitle: localizationService.localizedString(forKey: "home.highlight.topRated.subtitle", table: Screens.main.localizationTable, value: "Highly rated titles ready for deeper browsing.")
                )
            ]
        ))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
