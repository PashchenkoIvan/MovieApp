//
//  APIError.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case missingConfiguration(String)
    case invalidResponse
    case httpStatusCode(Int, Data)
    case decodingFailed(Error)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL."
        case .missingConfiguration(let key):
            return "Missing configuration value: \(key)."
        case .invalidResponse:
            return "Invalid server response."
        case .httpStatusCode(let statusCode, _):
            return "Request failed with status code \(statusCode)."
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}
