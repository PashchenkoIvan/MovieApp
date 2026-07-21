//
//  LoadingViewSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Testing
import UIKit

@testable import MovieApp

@MainActor
@Suite("LoadingView")
struct LoadingViewSuite {
    let loadingView = LoadingView()
    
    @Test("Init hides loading view")
    func initHidesLoadingView() {
        let loadingView = LoadingView()
        
        #expect(loadingView.isHidden == true)
    }
    
    @Test("Init creates activity indicator")
    func initCreatesActivityIndicator() {
        let activityIndicator = loadingView.firstSubview(of: UIActivityIndicatorView.self)
        
        #expect(activityIndicator != nil)
    }
    
    @Test("Start animating shows loading view")
    func startAnimatingShowsLoadingView() {
        loadingView.startAnimating()
        
        #expect(loadingView.isHidden == false)
    }
    
    @Test("Start animating starts activity indicator")
    func startAnimatingStartsActivityIndicator() throws {
        let activityIndicator = try #require(loadingView.firstSubview(of: UIActivityIndicatorView.self))
        
        loadingView.startAnimating()
        
        #expect(activityIndicator.isAnimating == true)
    }
    
    @Test("Stop animating hides loading view")
    func stopAnimatingHidesLoadingView() {
        loadingView.startAnimating()
        loadingView.stopAnimating()
        
        #expect(loadingView.isHidden == true)
    }
    
    @Test("Stop animating stops activity indicator")
    func stopAnimatingStopsActivityIndicator() throws {
        let activityIndicator = try #require(loadingView.firstSubview(of: UIActivityIndicatorView.self))
        
        loadingView.startAnimating()
        loadingView.stopAnimating()
        
        #expect(activityIndicator.isAnimating == false)
    }
}
