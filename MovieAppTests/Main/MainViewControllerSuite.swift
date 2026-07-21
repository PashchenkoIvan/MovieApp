//
//  MainViewControllerSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Testing
import UIKit

@testable import MovieApp

@MainActor
@Suite("MainViewController")
struct MainViewControllerSuite {
    @Test("Load view configures four tabs")
    func loadViewConfiguresFourTabs() throws {
        let viewController = MainViewController(viewModel: MainViewModel())

        viewController.loadViewIfNeeded()

        let tabs = try #require(viewController.viewControllers)
        #expect(tabs.count == 4)
    }

    @Test("Tabs are embedded in navigation controllers")
    func tabsAreEmbeddedInNavigationControllers() throws {
        let viewController = MainViewController(viewModel: MainViewModel())

        viewController.loadViewIfNeeded()

        let tabs = try #require(viewController.viewControllers)
        #expect(tabs.allSatisfy { $0 is UINavigationController })
    }

    @Test("Tabs use expected titles")
    func tabsUseExpectedTitles() throws {
        let viewController = MainViewController(viewModel: MainViewModel())

        viewController.loadViewIfNeeded()

        let tabs = try #require(viewController.viewControllers)
        #expect(tabs.map { $0.tabBarItem.title } == ["Home", "Search", "Favorites", "Account"])
    }

    @Test("Tabs use expected root controllers")
    func tabsUseExpectedRootControllers() throws {
        let viewController = MainViewController(viewModel: MainViewModel())

        viewController.loadViewIfNeeded()

        let tabs = try #require(viewController.viewControllers as? [UINavigationController])
        #expect(tabs[safe: 0]?.topViewController is HomeViewController)
        #expect(tabs[safe: 1]?.topViewController is SearchViewController)
        #expect(tabs[safe: 2]?.topViewController is FavoritesViewController)
        #expect(tabs[safe: 3]?.topViewController is AccountViewController)
    }

    @Test("Tab root controllers render placeholder structure")
    func tabRootControllersRenderPlaceholderStructure() throws {
        let viewController = MainViewController(viewModel: MainViewModel())

        viewController.loadViewIfNeeded()

        let tabs = try #require(viewController.viewControllers as? [UINavigationController])
        for tab in tabs {
            let rootViewController = try #require(tab.topViewController)
            rootViewController.loadViewIfNeeded()

            #expect(rootViewController.view.countSubviews(withAccessibilityIdentifier: "tabPlaceholder.hero") == 1)
            #expect(rootViewController.view.countSubviews(withAccessibilityIdentifier: "tabPlaceholder.highlight") == 3)
        }
    }
}


private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
private extension UIView {
    func countSubviews(withAccessibilityIdentifier accessibilityIdentifier: String) -> Int {
        let ownCount = self.accessibilityIdentifier == accessibilityIdentifier ? 1 : 0
        return subviews.reduce(ownCount) { count, subview in
            count + subview.countSubviews(withAccessibilityIdentifier: accessibilityIdentifier)
        }
    }
}

