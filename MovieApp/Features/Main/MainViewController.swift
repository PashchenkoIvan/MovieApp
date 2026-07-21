//
//  MainViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import UIKit

// MARK: - Main View Controller

/// Main app container with primary tabs.
final class MainViewController: UITabBarController {
    private let viewModel: MainViewModel
    private let localizationService: LocalizationServiceProtocol

    // MARK: - Init

    init(
        viewModel: MainViewModel,
        localizationService: LocalizationServiceProtocol = LocalizationService.shared
    ) {
        self.viewModel = viewModel
        self.localizationService = localizationService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupTabs()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
}

// MARK: - Private Setup

private extension MainViewController {
    func setupAppearance() {
        view.backgroundColor = .systemBackground

        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.25)

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .secondaryLabel
    }

    func setupTabs() {
        viewControllers = [
            makeNavigationController(
                rootViewController: HomeViewController(),
                titleKey: "main.tab.home",
                imageName: "house",
                selectedImageName: "house.fill"
            ),
            makeNavigationController(
                rootViewController: SearchViewController(),
                titleKey: "main.tab.search",
                imageName: "magnifyingglass",
                selectedImageName: "magnifyingglass"
            ),
            makeNavigationController(
                rootViewController: FavoritesViewController(),
                titleKey: "main.tab.favorites",
                imageName: "heart",
                selectedImageName: "heart.fill"
            ),
            makeNavigationController(
                rootViewController: AccountViewController(),
                titleKey: "main.tab.account",
                imageName: "person.crop.circle",
                selectedImageName: "person.crop.circle.fill"
            )
        ]
    }

    func makeNavigationController(
        rootViewController: UIViewController,
        titleKey: String,
        imageName: String,
        selectedImageName: String
    ) -> UINavigationController {
        let title = localized(titleKey)
        rootViewController.title = title

        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageName),
            selectedImage: UIImage(systemName: selectedImageName)
        )

        return navigationController
    }

    func localized(_ key: String) -> String {
        localizationService.localizedString(
            forKey: key,
            table: Screens.main.localizationTable,
            value: key
        )
    }
}
