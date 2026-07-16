//
//  AppCoordinator.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController
    private let dependencies: AppDependencyContainer
    private let logger = LogService()

    init(
        navigationController: UINavigationController,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        logger.log("Coordinator started", level: .info, category: .app)
        showRoot()
    }
}

// MARK: - RootRouting, LoginRouting

extension AppCoordinator: RootRouting, LoginRouting {
    func openMain() {
        showMain(animated: true)
    }

    func openLogin() {
        showLogin(animated: true)
    }
}

// MARK: - MainRouting

extension AppCoordinator: MainRouting {
    func openMovieDetails(_ movieId: UUID) {
        logger.routing(
            from: .main,
            to: .main,
            type: .push,
            animated: true
        )
        // TODO: Add MovieDetails screen and route to it from here.
    }
}

// MARK: - Private Navigation

private extension AppCoordinator {
    func showRoot() {
        let viewController = makeRootViewController()
        logger.routing(from: .root, to: .root, type: .set, animated: false)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showLogin(animated: Bool) {
        let viewController = makeLoginViewController()
        logger.routing(from: .root, to: .login, type: .push, animated: animated)
        navigationController.pushViewController(viewController, animated: animated)
    }

    func showMain(animated: Bool) {
        let viewController = makeMainViewController()
        logger.routing(from: .root, to: .main, type: .set, animated: animated)
        navigationController.setViewControllers([viewController], animated: animated)
    }
}

// MARK: - Screen Factory

private extension AppCoordinator {
    func makeRootViewController() -> RootViewController {
        let viewModel = RootViewModel()
        viewModel.router = self

        return RootViewController(
            viewModel: viewModel,
            screen: .root
        )
    }

    func makeLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel(loginUseCase: dependencies.loginUseCase)
        viewModel.router = self

        return LoginViewController(
            viewModel: viewModel,
            screen: .login
        )
    }

    func makeMainViewController() -> MainViewController {
        let viewModel = MainViewModel()
        viewModel.router = self

        return MainViewController(
            viewModel: viewModel,
            screen: .main
        )
    }
}
