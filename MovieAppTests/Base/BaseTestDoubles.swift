//
//  BaseTestDoubles.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import UIKit
@testable import MovieApp

// MARK: - Shared View State

enum FakeViewState: ViewState, Equatable {
    case idle
    case loading
    case loaded(String = "")
    case failed(String = "")

    var isLoading: Bool {
        self == .loading
    }
}

// MARK: - Shared Error

enum FakeError: LocalizedError {
    case failed
    
    var errorDescription: String? {
        "Error"
    }
}

// MARK: - ViewModel Spy

final class FakeViewModel: AnyViewModel {
    typealias State = FakeViewState
    
    var state: FakeViewState = .idle
    var onStateChanged: ((FakeViewState) -> Void)?

    private(set) var didCallViewDidLoad = false
    private(set) var didCallViewWillAppear = false
    private(set) var didCallViewDidAppear = false
    private(set) var didCallViewWillDisappear = false
    private(set) var didCallViewDidDisappear = false

    func setState(_ state: FakeViewState) {
        self.state = state
        onStateChanged?(state)
    }
    
    func viewDidLoad() {
        didCallViewDidLoad = true
    }

    func viewWillAppear() {
        didCallViewWillAppear = true
    }

    func viewDidAppear() {
        didCallViewDidAppear = true
    }

    func viewWillDisappear() {
        didCallViewWillDisappear = true
    }

    func viewDidDisappear() {
        didCallViewDidDisappear = true
    }
}

// MARK: - ViewController Spy

final class SpyBaseViewController: BaseViewController<FakeViewModel> {
    private(set) var didCallSetupUI = false
    private(set) var renderedStates: [FakeViewState] = []
    private(set) var events: [FakeViewControllerEvent] = []
    
    override func setupUI() {
        didCallSetupUI = true
        events.append(.setupUI)
    }
    
    override func render(_ state: FakeViewState) {
        renderedStates.append(state)
        events.append(.render(state))
    }
}

enum FakeViewControllerEvent: Equatable {
    case setupUI
    case render(FakeViewState)
}

// MARK: - View Helpers

extension UIView {
    func firstSubview<T: UIView>(of type: T.Type) -> T? {
        if let view = self as? T {
            return view
        }
        
        for subview in subviews {
            if let view = subview.firstSubview(of: type) {
                return view
            }
        }
        
        return nil
    }
}
