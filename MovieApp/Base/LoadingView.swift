//
//  LoadingView.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import SnapKit
import UIKit

// MARK: - Loading View

/// A shared loading overlay for all screens.
///
/// `BaseViewController` shows this view when `ViewState.isLoading` is `true`.
final class LoadingView: UIView {
    private let containerView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    /// Shows the overlay and starts the spinner.
    func startAnimating() {
        isHidden = false
        activityIndicator.startAnimating()
    }

    /// Stops the spinner and hides the overlay.
    func stopAnimating() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}

// MARK: - Private Setup

private extension LoadingView {
    func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.18)
        isHidden = true

        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true

        addSubview(containerView)
        containerView.addSubview(activityIndicator)

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(88)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
