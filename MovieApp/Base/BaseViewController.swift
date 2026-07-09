//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import SnapKit
import UIKit

class BaseViewController<V: AnyViewModel>: UIViewController {
    let viewModel: V
    let logger: LogService

    private let loadingView = LoadingView()

    init(viewModel: V, screen: Screens) {
        self.viewModel = viewModel
        self.logger = LogService(screen: screen)

        super.init(nibName: nil, bundle: nil)

        logger.screenLog("init")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.screenLog("viewDidLoad")

        setupUI()
        setupLoadingView()
        bindViewModel()
        renderState(viewModel.state)
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logger.screenLog("viewWillAppear")
        viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.screenLog("viewDidAppear")
        viewModel.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logger.screenLog("viewWillDisappear")
        viewModel.viewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logger.screenLog("viewDidDisappear")
        viewModel.viewDidDisappear()
    }

    // MARK: - Override Points

    func setupUI() {}

    func render(_ state: V.State) {}

    deinit {
        logger.screenLog("deinit")
    }
}

private extension BaseViewController {
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.renderState(state)
        }
    }

    func renderState(_ state: V.State) {
        setLoading(state.isLoading)
        render(state)
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}
