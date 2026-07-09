//
//  TMDBAuthAPI.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

protocol TMDBAuthAPIProtocol {
    func createRequestToken() async throws -> String
    func validateLogin(username: String, password: String, requestToken: String) async throws -> String
    func createSession(requestToken: String) async throws -> String
}

final class TMDBAuthAPI: TMDBAuthAPIProtocol {
    private let networkClient: NetworkClientProtocol
    private let encoder: JSONEncoder

    init(
        networkClient: NetworkClientProtocol,
        encoder: JSONEncoder = .tmdb
    ) {
        self.networkClient = networkClient
        self.encoder = encoder
    }

    func createRequestToken() async throws -> String {
        let endpoint = Endpoint(path: "/authentication/token/new")
        let response: RequestTokenResponseDTO = try await networkClient.request(endpoint)
        return response.requestToken
    }

    func validateLogin(username: String, password: String, requestToken: String) async throws -> String {
        let request = ValidateLoginRequestDTO(
            username: username,
            password: password,
            requestToken: requestToken
        )

        let endpoint = Endpoint(
            path: "/authentication/token/validate_with_login",
            method: .post,
            body: try encoder.encode(request)
        )

        let response: RequestTokenResponseDTO = try await networkClient.request(endpoint)
        return response.requestToken
    }

    func createSession(requestToken: String) async throws -> String {
        let request = CreateSessionRequestDTO(requestToken: requestToken)
        let endpoint = Endpoint(
            path: "/authentication/session/new",
            method: .post,
            body: try encoder.encode(request)
        )

        let response: CreateSessionResponseDTO = try await networkClient.request(endpoint)
        return response.sessionId
    }
}

private extension JSONEncoder {
    static var tmdb: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}
