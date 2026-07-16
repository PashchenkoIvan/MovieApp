//
//  ViewState.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

// MARK: - View State

/// A common state contract for every screen.
///
/// Use it to tell `BaseViewController` about shared UI flags,
/// for example loading state.
protocol ViewState {
    /// `true` when the screen should show the common loading overlay.
    var isLoading: Bool { get }
}

// MARK: - Default Values

extension ViewState {
    /// By default, the screen is not loading.
    var isLoading: Bool { false }
}

// MARK: - Empty State

/// A simple state for screens that do not need custom state yet.
enum EmptyViewState: ViewState {
    case idle
}
