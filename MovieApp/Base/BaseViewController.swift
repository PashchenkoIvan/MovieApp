//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import SnapKit
import UIKit

// MARK: - Base View Controller

/// Base class for all app view controllers.
///
/// It connects a screen with its ViewModel, listens to state changes,
/// shows the common loading overlay, and forwards lifecycle events.
class BaseViewController<V: AnyViewModel>: UIViewController {
    let viewModel: V
    let logger: LogService

    private let screen: Screens
    private let localizationService: LocalizationServiceProtocol
    private let loadingView = LoadingView()

    // MARK: - Init

    init(
        viewModel: V,
        screen: Screens,
        localizationService: LocalizationServiceProtocol = LocalizationService.shared
    ) {
        self.viewModel = viewModel
        self.screen = screen
        self.localizationService = localizationService
        self.logger = LogService(screen: screen)

        super.init(nibName: nil, bundle: nil)

        logger.lifecycle("init")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.lifecycle("viewDidLoad")

        setupUI()
        setupLoadingView()
        bindViewModel()
        renderState(viewModel.state)
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logger.lifecycle("viewWillAppear")
        viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.lifecycle("viewDidAppear")
        viewModel.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logger.lifecycle("viewWillDisappear")
        viewModel.viewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logger.lifecycle("viewDidDisappear")
        viewModel.viewDidDisappear()
    }

    // MARK: - Override Points

    /// Override this method in a child screen to create UI.
    func setupUI() {}

    /// Override this method in a child screen to render state.
    func render(_ state: V.State) {}

    // MARK: - Localization

    /// Gets localized text for this screen.
    ///
    /// The string catalog table is selected from `screen.localizationTable`.
    func localized(_ key: String, value: String = "") -> String {
        localizationService.localizedString(
            forKey: key,
            table: screen.localizationTable,
            value: value
        )
    }

    deinit {
        logger.lifecycle("deinit")
    }
}

// MARK: - Private Binding

private extension BaseViewController {
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// Connects ViewModel state changes to this screen.
    func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.renderState(state)
        }
    }

    /// Handles common state logic before screen-specific rendering.
    func renderState(_ state: V.State) {
        logger.state(
            "Render state",
            metadata: [
                "state": String(describing: state),
                "isLoading": String(state.isLoading)
            ]
        )
        setLoading(state.isLoading)
        render(state)
    }

    /// Shows or hides the common loading overlay.
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}
