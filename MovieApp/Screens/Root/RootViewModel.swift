//
//  RootViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import Foundation

final class RootViewModel: BaseViewModel {
    weak var router: RootRouting?

    private var didRouteFromRoot = false

    override func viewDidAppear() {
        super.viewDidAppear()
        routeToInitialFlowIfNeeded()
    }

    private func routeToInitialFlowIfNeeded() {
        guard !didRouteFromRoot else { return }
        didRouteFromRoot = true

        router?.openMain()
    }
}
