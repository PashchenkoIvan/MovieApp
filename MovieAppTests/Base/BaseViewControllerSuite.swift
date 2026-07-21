//
//  BaseViewControllerSuite.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Testing
import UIKit

@testable import MovieApp

@MainActor
@Suite("BaseViewController")
struct BaseViewControllerSuite {
    let viewController: SpyBaseViewController
    let viewModel: FakeViewModel
    
    init() {
        viewModel = FakeViewModel()
        viewController = SpyBaseViewController(
            viewModel: viewModel,
            screen: .main
        )
    }
    
    // MARK: - Init / Dependencies
    
    @Test("Init stored view model")
    func initStoresViewModel() {
        #expect(viewController.viewModel === viewModel)
    }
    
    @Test("Init does not load view")
    func initDoesNotLoadView() {
        #expect(viewController.isViewLoaded == false)
    }
    
    @Test("Init does not call view model lifecycle")
    func initDoesNotCallViewModelLifecycle() {
        #expect(viewModel.didCallViewDidLoad == false)
        #expect(viewModel.didCallViewWillAppear == false)
        #expect(viewModel.didCallViewDidAppear == false)
        #expect(viewModel.didCallViewWillDisappear == false)
        #expect(viewModel.didCallViewDidDisappear == false)
    }
    
    // MARK: - View Did Load
    
    @Test("Load view calls setup UI")
    func loadViewIfNeededCallsSetupUI() {
        viewController.loadViewIfNeeded()
        
        #expect(viewController.didCallSetupUI == true)
    }
    
    @Test("Load view adds loading view")
    func loadViewIfNeededAddsLoadingView() {
        viewController.loadViewIfNeeded()
        
        let loadingView = viewController.view.firstSubview(of: LoadingView.self)
        
        #expect(loadingView != nil)
    }
    
    @Test("Load view renders initial state")
    func loadViewIfNeededRendersInitialState() {
        viewController.loadViewIfNeeded()
        
        #expect(viewController.renderedStates == [.idle])
    }
    
    @Test("Load view calls view model view did load")
    func loadViewIfNeededCallsViewModelViewDidLoad() {
        viewController.loadViewIfNeeded()

        #expect(viewModel.didCallViewDidLoad == true)
    }
    
    @Test("Load view calls methods in expected order")
    func loadViewIfNeededCallsMethodsInExpectedOrder() {
        viewController.loadViewIfNeeded()
        
        #expect(viewController.events == [
            .setupUI,
            .render(.idle)
        ])
        #expect(viewModel.didCallViewDidLoad == true)
    }
    
    @Test("Load view binds view model state changes")
    func loadViewIfNeededBindsViewModelStateChanges() {
        viewController.loadViewIfNeeded()
        
        viewModel.setState(.loaded())
        
        #expect(viewController.renderedStates == [.idle, .loaded()])
    }
    
    @Test("Load view renders initial state only once")
    func loadViewIfNeededRendersInitialStateOnlyOnce() {
        viewController.loadViewIfNeeded()
        viewController.loadViewIfNeeded()
        
        #expect(viewController.renderedStates == [.idle])
    }
    
    // MARK: - Lifecycle Forwarding
    
    @Test("View will appear calls view model view will appear")
    func viewWillAppearCallsViewModelViewWillAppear() {
        viewController.viewWillAppear(false)
        
        #expect(viewModel.didCallViewWillAppear == true)
    }
    
    @Test("View did appear calls view model view did appear")
    func viewDidAppearCallsViewModelViewDidAppear() {
        viewController.viewDidAppear(false)
        
        #expect(viewModel.didCallViewDidAppear == true)
    }
    
    @Test("View will disappear calls view model view will disappear")
    func viewWillDisappearCallsViewModelViewWillDisappear() {
        viewController.viewWillDisappear(false)
        
        #expect(viewModel.didCallViewWillDisappear == true)
    }
    
    @Test("View did disappear calls view model view did disappear")
    func viewDidDisappearCallsViewModelViewDidDisappear() {
        viewController.viewDidDisappear(false)
        
        #expect(viewModel.didCallViewDidDisappear == true)
    }
    
    @Test("Appearance transition calls appear lifecycle")
    func appearanceTransitionCallsAppearLifecycle() {
        viewController.loadViewIfNeeded()
        
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        
        #expect(viewModel.didCallViewWillAppear == true)
        #expect(viewModel.didCallViewDidAppear == true)
    }
    
    @Test("Appearance transition calls disappear lifecycle")
    func appearanceTransitionCallsDisappearLifecycle() {
        viewController.loadViewIfNeeded()
        
        viewController.beginAppearanceTransition(false, animated: false)
        viewController.endAppearanceTransition()
        
        #expect(viewModel.didCallViewWillDisappear == true)
        #expect(viewModel.didCallViewDidDisappear == true)
    }
    
    // MARK: - State Rendering
    
    @Test("State change does not render before view did load")
    func stateChangeDoesNotRenderBeforeViewDidLoad() {
        viewModel.setState(.loaded())
        
        #expect(viewController.renderedStates.isEmpty)
    }
    
    @Test("State change passes new state to render")
    func stateChangePassesNewStateToRender() {
        viewController.loadViewIfNeeded()
        
        viewModel.setState(.loaded())
        
        #expect(viewController.renderedStates.last == .loaded())
    }
    
    @Test("Multiple state changes call render every time")
    func multipleStateChangesCallRenderEveryTime() {
        viewController.loadViewIfNeeded()
        
        viewModel.setState(.loading)
        viewModel.setState(.loaded())
        viewModel.setState(.failed())
        
        #expect(viewController.renderedStates == [.idle, .loading, .loaded(), .failed()])
    }
    
    @Test("Loading overlay does not block render")
    func loadingOverlayDoesNotBlockRender() {
        viewController.loadViewIfNeeded()
        
        viewModel.setState(.loading)
        
        #expect(viewController.renderedStates.contains(.loading))
    }
    
    // MARK: - Loading
    
    @Test("Initial idle state hides loading view")
    func initialIdleStateHidesLoadingView() throws {
        viewController.loadViewIfNeeded()
        
        let loadingView = try #require(viewController.view.firstSubview(of: LoadingView.self))
        
        #expect(loadingView.isHidden == true)
    }
    
    @Test("Initial loading state shows loading view")
    func initialLoadingStateShowsLoadingView() throws {
        viewModel.state = .loading
        viewController.loadViewIfNeeded()
        
        let loadingView = try #require(viewController.view.firstSubview(of: LoadingView.self))
        
        #expect(loadingView.isHidden == false)
    }
    
    @Test("Loading state change shows loading view")
    func loadingStateChangeShowsLoadingView() throws {
        viewController.loadViewIfNeeded()
        
        viewModel.setState(.loading)
        let loadingView = try #require(viewController.view.firstSubview(of: LoadingView.self))
        
        #expect(loadingView.isHidden == false)
    }
    
    @Test("Non loading state change hides loading view")
    func nonLoadingStateChangeHidesLoadingView() throws {
        viewController.loadViewIfNeeded()
        
        viewModel.setState(.loading)
        viewModel.setState(.loaded())
        let loadingView = try #require(viewController.view.firstSubview(of: LoadingView.self))
        
        #expect(loadingView.isHidden == true)
    }
    
    // MARK: - Localization
    
    @Test("Localized returns fallback value when key is missing")
    func localizedReturnsFallbackValueWhenKeyIsMissing() {
        let value = viewController.localized(
            "missing_key_for_test",
            value: "Fallback"
        )
        
        #expect(value == "Fallback")
    }
    
    @Test("Localized does not crash for screen without table")
    func localizedDoesNotCrashForScreenWithoutTable() {
        let viewController = SpyBaseViewController(
            viewModel: viewModel,
            screen: .root
        )
        let value = viewController.localized(
            "missing_key_for_root_test",
            value: "Root fallback"
        )
        
        #expect(value == "Root fallback")
    }
}

