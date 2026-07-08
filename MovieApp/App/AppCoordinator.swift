//
//  AppCoordinator.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import UIKit

protocol RootRouting: AnyObject {
    func openMain()
    func openLogin()
}

protocol LoginRouting: AnyObject {
    func openMain()
}

protocol MainRouting: AnyObject {
    func openMovieDetails(_ movieId: UUID)
}

final class AppCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showRoot()
    }
    
    private func showRoot() {
        let viewModel = RootViewModel()
        let viewController = RootViewController(
            viewModel: viewModel,
            screen: .root
        )

        viewModel.router = self

        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func showLogin() {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(
            viewModel: viewModel,
            screen: .login
        )
        
        viewModel.router = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showMain() {
        let viewModel = MainViewModel()
        let viewController = MainViewController(
            viewModel: viewModel,
            screen: .main
        )
        
        viewModel.router = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: RootRouting, LoginRouting {
    func openMain() {
        showMain()
    }
    
    func openLogin() {
        showLogin()
    }
}

extension AppCoordinator: MainRouting {
    func openMovieDetails(_ movieId: UUID) {
//        showMoviewDetails(movieId: movieId)
    }
}
