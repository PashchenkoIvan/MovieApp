//
//  BaseViewModelSuite.swift
//  MovieApp
//
//  Created by Ivan P. on 17/07/2026.
//

import Testing
import Foundation
@testable import MovieApp

@MainActor
@Suite("BaseViewModel")
struct BaseViewModelSuite {
    let viewModel = BaseViewModel<FakeViewState>(initialState: .idle)
    
    @Test("Initial test is stored")
    func initialStateIsStored() {
        #expect(viewModel.state == .idle)
    }
    
    @Test("Set state updates current state")
    func setStateUpdatesState() {
        viewModel.setState(.loaded("OK"))
        
        #expect(viewModel.state == .loaded("OK"))
    }
    
    @Test("Set state calls on state changed")
    func setStateCallsOnStateChanged() {
        var receivedState: FakeViewState?
        viewModel.onStateChanged = { receivedState = $0 }
        
        viewModel.setState(.loaded("OK"))
        
        #expect(receivedState == .loaded("OK"))
    }
    
    @Test("Set state calls on state changed every time")
    func setStateCallsOnStateChangedEveryTime() {
        var states: [FakeViewState] = []
        viewModel.onStateChanged = { states.append($0) }
        
        viewModel.setState(.loading)
        viewModel.setState(.loaded("OK"))
        
        #expect(states == [.loading, .loaded("OK")])
    }
    
    @Test("Set state without observer does not crash")
    func setStateWithoutObserverDoesNotCrash() {
        viewModel.onStateChanged = nil
        
        viewModel.setState(.loaded("OK"))
        
        #expect(viewModel.state == .loaded("OK"))
    }
    
    @Test("Server request sets loading state")
    func serverRequestSetsLoadingState() async {
        let task = viewModel.performServerRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { "OK" },
            onSuccess: { (_: String) in }
        )
        
        #expect(viewModel.state == .loading)
        
        await task.value
    }
    
    @Test("Server request calls success")
    func serverRequestCallsSuccess() async {
        var response: String?
        let task = viewModel.performServerRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { "OK" },
            onSuccess: { response = $0 }
        )
        
        await task.value
        
        #expect(response == "OK")
    }
    
    @Test("Server request does not set success state by itself")
    func serverRequestDoesNotSetSuccessStateByItself() async {
        let task = viewModel.performServerRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { "OK" },
            onSuccess: { (_: String) in }
        )
        
        await task.value
        
        #expect(viewModel.state == .loading)
    }
    
    @Test("Server request sets failure state on error")
    func serverRequestSetsFailureStateOnError() async {
        let task = viewModel.performServerRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { throw FakeError.failed },
            onSuccess: { (_: String) in }
        )
        
        await task.value
        
        #expect(viewModel.state == .failed("Error"))
    }
    
    @Test("Server request emits loading and failure states on error")
    func serverRequestEmitsLoadingAndFailureStatesOnError() async {
        var states: [FakeViewState] = []
        viewModel.onStateChanged = { states.append($0) }
        
        let task = viewModel.performServerRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { throw FakeError.failed },
            onSuccess: { (_: String) in }
        )
        
        await task.value
        
        #expect(states == [.loading, .failed("Error")])
    }
    
    @Test("Server request does not call success on error")
    func serverRequestDoesNotCallSuccessOnError() async {
        var didCallSuccess = false
        let task = viewModel.performServerRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { throw FakeError.failed },
            onSuccess: { (_: String) in didCallSuccess = true }
        )
        
        await task.value
        
        #expect(didCallSuccess == false)
    }
    
    @Test("Local storage request without loading state does not change state")
    func localStorageRequestWithoutLoadingStateDoesNotChangeState() async {
        let task = viewModel.performLocalStorageRequest(
            failureState: { .failed($0) },
            request: { "OK" },
            onSuccess: { (_: String) in }
        )
        
        await task.value
        
        #expect(viewModel.state == .idle)
    }
    
    @Test("Local storage request with loading state sets loading")
    func localStorageRequestWithLoadingStateSetsLoading() async {
        let task = viewModel.performLocalStorageRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { "OK" },
            onSuccess: { (_: String) in }
        )
        
        #expect(viewModel.state == .loading)
        
        await task.value
    }
    
    @Test("Local storage request calls success")
    func localStorageRequestCallsSuccess() async {
        var response: String?
        let task = viewModel.performLocalStorageRequest(
            failureState: { .failed($0) },
            request: { "OK" },
            onSuccess: { response = $0 }
        )
        
        await task.value
        
        #expect(response == "OK")
    }
    
    @Test("Local storage request with loading emits loading state")
    func localStorageRequestWithLoadingEmitsLoadingState() async {
        var states: [FakeViewState] = []
        viewModel.onStateChanged = { states.append($0) }
        
        let task = viewModel.performLocalStorageRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { "OK" },
            onSuccess: { (_: String) in }
        )
        
        await task.value
        
        #expect(states == [.loading])
    }
    
    @Test("Local storage request sets failure state on error")
    func localStorageRequestSetsFailureStateOnError() async {
        let task = viewModel.performLocalStorageRequest(
            failureState: { .failed($0) },
            request: { throw FakeError.failed },
            onSuccess: { (_: String) in }
        )
        
        await task.value
        
        #expect(viewModel.state == .failed("Error"))
    }
    
    @Test("Local storage request with loading emits loading and failure states on error")
    func localStorageRequestWithLoadingEmitsLoadingAndFailureStatesOnError() async {
        var states: [FakeViewState] = []
        viewModel.onStateChanged = { states.append($0) }
        
        let task = viewModel.performLocalStorageRequest(
            loadingState: .loading,
            failureState: { .failed($0) },
            request: { throw FakeError.failed },
            onSuccess: { (_: String) in }
        )
        
        await task.value
        
        #expect(states == [.loading, .failed("Error")])
    }
    
    @Test("Local storage request does not call success on error")
    func localStorageRequestDoesNotCallSuccessOnError() async {
        var didCallSuccess = false
        let task = viewModel.performLocalStorageRequest(
            failureState: { .failed($0) },
            request: { throw FakeError.failed },
            onSuccess: { (_: String) in didCallSuccess = true }
        )
        
        await task.value
        
        #expect(didCallSuccess == false)
    }
    
    @Test("Lifecycle methods do not change state")
    func lifecycleMethodsDoNotChangeState() {
        viewModel.setState(.loaded("OK"))
        
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.viewDidAppear()
        viewModel.viewWillDisappear()
        viewModel.viewDidDisappear()
        
        #expect(viewModel.state == .loaded("OK"))
    }
    
    @Test("Empty view state convenience init uses idle")
    func emptyViewStateConvenienceInitUsesIdle() {
        let viewModel = BaseViewModel<EmptyViewState>()
        
        #expect(viewModel.state == .idle)
    }
}
