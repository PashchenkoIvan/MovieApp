//
//  APIErrorSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@Suite("APIError")
struct APIErrorSuite {
    @Test("Descriptions are user readable")
    func descriptionsAreUserReadable() {
        #expect(APIError.invalidURL.localizedDescription == "Invalid API URL.")
        #expect(APIError.missingConfiguration("Token").localizedDescription == "Missing configuration value: Token.")
        #expect(APIError.invalidResponse.localizedDescription == "Invalid server response.")
        #expect(APIError.httpStatusCode(404, Data()).localizedDescription == "Request failed with status code 404.")
        #expect(APIError.underlying(URLError(.notConnectedToInternet)).localizedDescription == URLError(.notConnectedToInternet).localizedDescription)
    }

    @Test("Decoding failed description includes underlying message")
    func decodingFailedDescriptionIncludesUnderlyingMessage() {
        struct Model: Decodable {
            let value: String
        }

        let caughtError: Error
        do {
            _ = try JSONDecoder().decode(Model.self, from: Data(#"{"other":"value"}"#.utf8))
            Issue.record("Expected decoding to fail")
            return
        } catch {
            caughtError = error
        }

        #expect(APIError.decodingFailed(caughtError).localizedDescription.contains("Failed to decode response:"))
    }
}
