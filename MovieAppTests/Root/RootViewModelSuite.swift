//
//  RootViewModelSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Testing

@testable import MovieApp

@MainActor
@Suite("RootViewModel")
struct RootViewModelSuite {
    @Test("Init uses idle state")
    func initUsesIdleState() {
        let viewModel = RootViewModel()

        #expect(viewModel.state == .idle)
    }

    @Test("View did appear opens main")
    func viewDidAppearOpensMain() {
        let router = RootRouterSpy()
        let viewModel = RootViewModel()
        viewModel.router = router

        viewModel.viewDidAppear()

        #expect(router.openMainCallCount == 1)
        #expect(router.openLoginCallCount == 0)
    }

    @Test("Repeated view did appear routes only once")
    func repeatedViewDidAppearRoutesOnlyOnce() {
        let router = RootRouterSpy()
        let viewModel = RootViewModel()
        viewModel.router = router

        viewModel.viewDidAppear()
        viewModel.viewDidAppear()
        viewModel.viewDidAppear()

        #expect(router.openMainCallCount == 1)
    }

    @Test("View did appear without router does not crash")
    func viewDidAppearWithoutRouterDoesNotCrash() {
        let viewModel = RootViewModel()

        viewModel.viewDidAppear()

        #expect(viewModel.state == .idle)
    }
}

private final class RootRouterSpy: RootRouting {
    private(set) var openMainCallCount = 0
    private(set) var openLoginCallCount = 0

    func openMain() {
        openMainCallCount += 1
    }

    func openLogin() {
        openLoginCallCount += 1
    }
}
