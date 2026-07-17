//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import Foundation

// MARK: - View Controller Lifecycle

/// Lifecycle events from a `UIViewController`.
///
/// A ViewModel can implement these methods when it needs to react
/// to screen lifecycle changes.
protocol VCLifecycle: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

// MARK: - ViewModel Contract

/// A common interface for all ViewModels in the app.
protocol AnyViewModel: AnyObject, VCLifecycle {
    associatedtype State: ViewState

    /// Current screen state.
    var state: State { get }

    /// Called when the state changes.
    var onStateChanged: ((State) -> Void)? { get set }
}

// MARK: - Base ViewModel

/// Base class for screen ViewModels.
///
/// It stores the screen state, sends state updates to `BaseViewController`,
/// and gives common helpers for server and local storage work.
class BaseViewModel<State: ViewState>: AnyViewModel {
    /// The current screen state.
    ///
    /// Other objects can read it, but only this class can change it.
    private(set) var state: State

    /// Shared local storage for ViewModels that need SwiftData.
    ///
    /// This value is optional because not every screen needs local storage.
    let localStorage: SwiftDataStorage?

    /// `BaseViewController` uses this closure to update UI when state changes.
    var onStateChanged: ((State) -> Void)?

    private let logger = LogService()

    // MARK: - Init

    init(
        initialState: State,
        localStorage: SwiftDataStorage? = nil
    ) {
        self.state = initialState
        self.localStorage = localStorage

        logger.state(
            "Initial state",
            metadata: [
                "state": String(describing: initialState),
                "hasLocalStorage": String(localStorage != nil)
            ]
        )
    }

    // MARK: - State

    /// Changes the current state and tells the screen about it.
    final func setState(_ state: State) {
        logger.state(
            "State changed",
            metadata: [
                "from": String(describing: self.state),
                "to": String(describing: state),
                "isLoading": String(state.isLoading)
            ]
        )
        self.state = state
        onStateChanged?(state)
    }

    // MARK: - Server Request

    /// Runs async server work with the same loading and error flow for every screen.
    ///
    /// - Parameters:
    ///   - loadingState: State used while the request is running.
    ///   - failureState: Creates an error state from an error message.
    ///   - request: Async server work.
    ///   - onSuccess: Called on the main actor after a successful request.
    @discardableResult
    final func performServerRequest<Response>(
        loadingState: State,
        failureState: @escaping (String) -> State,
        request: @escaping () async throws -> Response,
        onSuccess: @escaping (Response) -> Void
    ) -> Task<Void, Never> {
        logger.network(
            "Server request started",
            metadata: ["loadingState": String(describing: loadingState)]
        )
        setState(loadingState)

        return Task { [weak self] in
            do {
                let response = try await request()
                guard !Task.isCancelled else {
                    self?.logger.network("Server request cancelled")
                    return
                }

                await MainActor.run {
                    self?.logger.network(
                        "Server request succeeded",
                        level: .info,
                        metadata: ["response": String(describing: Response.self)]
                    )
                    onSuccess(response)
                }
            } catch {
                guard !Task.isCancelled else {
                    self?.logger.network("Server request cancelled")
                    return
                }

                await MainActor.run {
                    self?.logger.network(
                        "Server request failed",
                        level: .error,
                        metadata: ["error": error.localizedDescription]
                    )
                    self?.setState(failureState(error.localizedDescription))
                }
            }
        }
    }

    // MARK: - Local Storage Request

    /// Runs local storage work with the same loading and error flow for every screen.
    ///
    /// Use this for SwiftData reads and writes from a screen ViewModel.
    /// Network caching should still live in repositories, not in `NetworkClient`.
    ///
    /// - Parameters:
    ///   - loadingState: Optional state used while the storage work is running.
    ///   - failureState: Creates an error state from an error message.
    ///   - request: Local storage work.
    ///   - onSuccess: Called after successful local storage work.
    @discardableResult
    final func performLocalStorageRequest<Response>(
        loadingState: State? = nil,
        failureState: @escaping (String) -> State,
        request: @escaping () throws -> Response,
        onSuccess: @escaping (Response) -> Void
    ) -> Task<Void, Never> {
        logger.log(
            "Local storage request started",
            level: .debug,
            category: .app,
            metadata: [
                "loadingState": loadingState.map { String(describing: $0) } ?? "none"
            ]
        )

        if let loadingState {
            setState(loadingState)
        }

        return Task { @MainActor [weak self] in
            do {
                let response = try request()
                guard !Task.isCancelled else {
                    self?.logger.log(
                        "Local storage request cancelled",
                        level: .debug,
                        category: .app
                    )
                    return
                }

                self?.logger.log(
                    "Local storage request succeeded",
                    level: .info,
                    category: .app,
                    metadata: ["response": String(describing: Response.self)]
                )
                onSuccess(response)
            } catch {
                guard !Task.isCancelled else {
                    self?.logger.log(
                        "Local storage request cancelled",
                        level: .debug,
                        category: .app
                    )
                    return
                }

                self?.logger.log(
                    "Local storage request failed",
                    level: .error,
                    category: .app,
                    metadata: ["error": error.localizedDescription]
                )
                self?.setState(failureState(error.localizedDescription))
            }
        }
    }

    // MARK: - Lifecycle

    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}

// MARK: - Empty State Support

extension BaseViewModel where State == EmptyViewState {
    /// Use this init for screens that do not need a custom state yet.
    convenience init(localStorage: SwiftDataStorage? = nil) {
        self.init(initialState: .idle, localStorage: localStorage)
    }
}
