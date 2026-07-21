//
//  NetworkClientSpy.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
@testable import MovieApp

final class NetworkClientSpy: NetworkClientProtocol {
    private(set) var receivedEndpoints: [Endpoint] = []
    var result: Result<Any, Error>?

    func request<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        receivedEndpoints.append(endpoint)

        guard let result else {
            throw NetworkClientSpyError.missingResult
        }

        switch result {
        case .success(let value):
            guard let response = value as? Response else {
                throw NetworkClientSpyError.responseTypeMismatch
            }
            return response
        case .failure(let error):
            throw error
        }
    }
}

enum NetworkClientSpyError: Error, Equatable {
    case missingResult
    case responseTypeMismatch
}
