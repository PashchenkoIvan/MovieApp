//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import UIKit

class BaseViewController<V: AnyViewModel>: UIViewController {
    let viewModel: V
    let logger: LogService
    
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
    
    deinit {
        logger.screenLog("deinit")
    }
}
