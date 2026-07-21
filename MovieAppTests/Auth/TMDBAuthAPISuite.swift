//
//  TMDBAuthAPISuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@MainActor
@Suite("TMDBAuthAPI")
struct TMDBAuthAPISuite {
    @Test("Create request token builds endpoint and returns token")
    func createRequestTokenBuildsEndpointAndReturnsToken() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .success(RequestTokenResponseDTO(
            success: true,
            expiresAt: "2026-07-21 12:00:00 UTC",
            requestToken: "request-token"
        ))
        let api = TMDBAuthAPI(networkClient: networkClient)

        let token = try await api.createRequestToken()

        let endpoint = try #require(networkClient.receivedEndpoints.first)
        #expect(token == "request-token")
        #expect(endpoint.path == "/authentication/token/new")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty)
        #expect(endpoint.body == nil)
    }

    @Test("Validate login builds endpoint and returns token")
    func validateLoginBuildsEndpointAndReturnsToken() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .success(RequestTokenResponseDTO(
            success: true,
            expiresAt: "2026-07-21 12:00:00 UTC",
            requestToken: "validated-token"
        ))
        let api = TMDBAuthAPI(networkClient: networkClient)

        let token = try await api.validateLogin(
            username: "username",
            password: "password",
            requestToken: "request-token"
        )

        let endpoint = try #require(networkClient.receivedEndpoints.first)
        let body = try #require(endpoint.body)
        let json = try decodedJSON(from: body)

        #expect(token == "validated-token")
        #expect(endpoint.path == "/authentication/token/validate_with_login")
        #expect(endpoint.method == .post)
        #expect(json["username"] as? String == "username")
        #expect(json["password"] as? String == "password")
        #expect(json["request_token"] as? String == "request-token")
    }

    @Test("Create session builds endpoint and returns session id")
    func createSessionBuildsEndpointAndReturnsSessionId() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .success(CreateSessionResponseDTO(
            success: true,
            sessionId: "session-id"
        ))
        let api = TMDBAuthAPI(networkClient: networkClient)

        let sessionId = try await api.createSession(requestToken: "request-token")

        let endpoint = try #require(networkClient.receivedEndpoints.first)
        let body = try #require(endpoint.body)
        let json = try decodedJSON(from: body)

        #expect(sessionId == "session-id")
        #expect(endpoint.path == "/authentication/session/new")
        #expect(endpoint.method == .post)
        #expect(json["request_token"] as? String == "request-token")
    }

    @Test("Create request token propagates network error")
    func createRequestTokenPropagatesNetworkError() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .failure(APIError.invalidResponse)
        let api = TMDBAuthAPI(networkClient: networkClient)

        do {
            _ = try await api.createRequestToken()
            Issue.record("Expected network error")
        } catch APIError.invalidResponse {
            #expect(true)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Validate login propagates network error")
    func validateLoginPropagatesNetworkError() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .failure(APIError.invalidResponse)
        let api = TMDBAuthAPI(networkClient: networkClient)

        do {
            _ = try await api.validateLogin(
                username: "username",
                password: "password",
                requestToken: "request-token"
            )
            Issue.record("Expected network error")
        } catch APIError.invalidResponse {
            #expect(true)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Create session propagates network error")
    func createSessionPropagatesNetworkError() async throws {
        let networkClient = NetworkClientSpy()
        networkClient.result = .failure(APIError.invalidResponse)
        let api = TMDBAuthAPI(networkClient: networkClient)

        do {
            _ = try await api.createSession(requestToken: "request-token")
            Issue.record("Expected network error")
        } catch APIError.invalidResponse {
            #expect(true)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private func decodedJSON(from data: Data) throws -> [String: Any] {
    let object = try JSONSerialization.jsonObject(with: data)
    guard let dictionary = object as? [String: Any] else {
        throw DecodedJSONError.notDictionary
    }
    return dictionary
}

private enum DecodedJSONError: Error {
    case notDictionary
}
