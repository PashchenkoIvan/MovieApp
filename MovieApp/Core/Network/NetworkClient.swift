//
//  NetworkClient.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

protocol NetworkClientProtocol {
    func request<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response
}

final class NetworkClient: NetworkClientProtocol {
    private let configuration: TMDBConfiguration
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        configuration: TMDBConfiguration,
        session: URLSession = .shared,
        decoder: JSONDecoder = .tmdb
    ) {
        self.configuration = configuration
        self.session = session
        self.decoder = decoder
    }

    func request<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        let request = try makeRequest(from: endpoint)

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.httpStatusCode(httpResponse.statusCode, data)
            }

            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw APIError.decodingFailed(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.underlying(error)
        }
    }

    private func makeRequest(from endpoint: Endpoint) throws -> URLRequest {
        let url = configuration.baseURL.appending(path: endpoint.path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("Bearer \(configuration.readAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if endpoint.body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

private extension JSONDecoder {
    static var tmdb: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
