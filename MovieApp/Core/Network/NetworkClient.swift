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
    private let logger = LogService()

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
        let startedAt = Date()

        logger.network(
            "Request started",
            level: .info,
            metadata: requestMetadata(for: request, endpoint: endpoint)
        )

        do {
            let (data, response) = try await session.data(for: request)
            let duration = Date().timeIntervalSince(startedAt)

            guard let httpResponse = response as? HTTPURLResponse else {
                logger.network(
                    "Invalid response",
                    level: .error,
                    metadata: ["duration": formatDuration(duration)]
                )
                throw APIError.invalidResponse
            }

            logger.network(
                "Response received",
                level: .info,
                metadata: [
                    "statusCode": String(httpResponse.statusCode),
                    "bytes": String(data.count),
                    "duration": formatDuration(duration)
                ]
            )

            guard 200..<300 ~= httpResponse.statusCode else {
                logger.network(
                    "Request failed with status code",
                    level: .error,
                    metadata: [
                        "statusCode": String(httpResponse.statusCode),
                        "bytes": String(data.count),
                        "duration": formatDuration(duration)
                    ]
                )
                throw APIError.httpStatusCode(httpResponse.statusCode, data)
            }

            do {
                let decodedResponse = try decoder.decode(Response.self, from: data)
                logger.network(
                    "Response decoded",
                    level: .debug,
                    metadata: ["type": String(describing: Response.self)]
                )
                return decodedResponse
            } catch {
                logger.network(
                    "Response decoding failed",
                    level: .error,
                    metadata: [
                        "type": String(describing: Response.self),
                        "error": error.localizedDescription
                    ]
                )
                throw APIError.decodingFailed(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            logger.network(
                "Request failed",
                level: .error,
                metadata: ["error": error.localizedDescription]
            )
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

private extension NetworkClient {
    func requestMetadata(for request: URLRequest, endpoint: Endpoint) -> [String: String] {
        [
            "method": request.httpMethod ?? endpoint.method.rawValue,
            "url": request.url?.absoluteString ?? "unknown",
            "hasBody": String(request.httpBody != nil),
            "queryItems": String(endpoint.queryItems.count)
        ]
    }

    func formatDuration(_ duration: TimeInterval) -> String {
        String(format: "%.3fs", duration)
    }
}

private extension JSONDecoder {
    static var tmdb: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
