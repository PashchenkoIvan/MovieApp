//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import UIKit

protocol VCLifecycle: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

protocol AnyViewModel: AnyObject, VCLifecycle {}

class BaseViewModel: AnyViewModel {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}
