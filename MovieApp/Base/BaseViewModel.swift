//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import Foundation

protocol VCLifecycle: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

protocol AnyViewModel: AnyObject, VCLifecycle {
    associatedtype State: ViewState

    var state: State { get }
    var onStateChanged: ((State) -> Void)? { get set }
}

class BaseViewModel<State: ViewState>: AnyViewModel {
    private(set) var state: State
    var onStateChanged: ((State) -> Void)?

    init(initialState: State) {
        self.state = initialState
    }

    func setState(_ state: State) {
        self.state = state
        onStateChanged?(state)
    }

    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}

extension BaseViewModel where State == EmptyViewState {
    convenience init() {
        self.init(initialState: .idle)
    }
}
