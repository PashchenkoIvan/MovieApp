//
//  AccountViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import UIKit

final class AccountViewController: TabPlaceholderViewController {
    init(localizationService: LocalizationServiceProtocol = LocalizationService.shared) {
        super.init(configuration: TabPlaceholderConfiguration(
            iconName: "person.crop.circle.fill",
            title: localizationService.localizedString(forKey: "account.title", table: Screens.main.localizationTable, value: "Account"),
            subtitle: localizationService.localizedString(forKey: "account.subtitle", table: Screens.main.localizationTable, value: "Session, profile, and TMDB activity."),
            accentColor: .systemOrange,
            highlights: [
                TabPlaceholderHighlight(
                    iconName: "key.fill",
                    title: localizationService.localizedString(forKey: "account.highlight.session.title", table: Screens.main.localizationTable, value: "Session"),
                    subtitle: localizationService.localizedString(forKey: "account.highlight.session.subtitle", table: Screens.main.localizationTable, value: "Authentication state stays isolated from presentation.")
                ),
                TabPlaceholderHighlight(
                    iconName: "person.text.rectangle.fill",
                    title: localizationService.localizedString(forKey: "account.highlight.profile.title", table: Screens.main.localizationTable, value: "Profile"),
                    subtitle: localizationService.localizedString(forKey: "account.highlight.profile.subtitle", table: Screens.main.localizationTable, value: "Account details will have a dedicated surface.")
                ),
                TabPlaceholderHighlight(
                    iconName: "slider.horizontal.3",
                    title: localizationService.localizedString(forKey: "account.highlight.settings.title", table: Screens.main.localizationTable, value: "Settings"),
                    subtitle: localizationService.localizedString(forKey: "account.highlight.settings.subtitle", table: Screens.main.localizationTable, value: "Preferences and sign out actions belong here.")
                )
            ]
        ))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
