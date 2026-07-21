//
//  NetworkClientSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@Suite("NetworkClient", .serialized)
struct NetworkClientSuite {
    init() {
        URLProtocolMock.reset()
    }

    @Test("Request builds URL with base path and query items")
    func requestBuildsURLWithBasePathAndQueryItems() async throws {
        let client = makeClient()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{"request_token":"token"}"#.utf8))
        }

        let response: DecodableResponse = try await client.request(Endpoint(
            path: "/authentication/token/new",
            queryItems: [URLQueryItem(name: "language", value: "en-US")]
        ))

        let request = try #require(URLProtocolMock.receivedRequests.first)
        #expect(request.url?.absoluteString == "https://api.test.themoviedb.org/3/authentication/token/new?language=en-US")
        #expect(response.requestToken == "token")
    }

    @Test("Request adds authorization and accept headers")
    func requestAddsAuthorizationAndAcceptHeaders() async throws {
        let client = makeClient(token: "read-token")
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{"request_token":"token"}"#.utf8))
        }

        let _: DecodableResponse = try await client.request(Endpoint(path: "/authentication/token/new"))

        let request = try #require(URLProtocolMock.receivedRequests.first)
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer read-token")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test("Request adds content type when body exists")
    func requestAddsContentTypeWhenBodyExists() async throws {
        let client = makeClient()
        let body = Data(#"{"request_token":"token"}"#.utf8)
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{"session_id":"session"}"#.utf8))
        }

        let _: SessionResponse = try await client.request(Endpoint(
            path: "/authentication/session/new",
            method: .post,
            body: body
        ))

        let request = try #require(URLProtocolMock.receivedRequests.first)
        #expect(request.httpMethod == "POST")
        #expect(request.httpBodyData() == body)
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test("Request applies custom headers")
    func requestAppliesCustomHeaders() async throws {
        let client = makeClient()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{"request_token":"token"}"#.utf8))
        }

        let _: DecodableResponse = try await client.request(Endpoint(
            path: "/authentication/token/new",
            headers: ["X-Test": "custom"]
        ))

        let request = try #require(URLProtocolMock.receivedRequests.first)
        #expect(request.value(forHTTPHeaderField: "X-Test") == "custom")
    }

    @Test("Request decodes snake case JSON")
    func requestDecodesSnakeCaseJSON() async throws {
        let client = makeClient()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{"request_token":"token"}"#.utf8))
        }

        let response: DecodableResponse = try await client.request(Endpoint(path: "/authentication/token/new"))

        #expect(response.requestToken == "token")
    }

    @Test("Request throws invalid response for non HTTP response")
    func requestThrowsInvalidResponseForNonHTTPResponse() async throws {
        let client = makeClient()
        URLProtocolMock.requestHandler = { request in
            let url = try makeURL(for: request)
            return (URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil), Data())
        }

        do {
            let _: DecodableResponse = try await client.request(Endpoint(path: "/authentication/token/new"))
            Issue.record("Expected invalid response error")
        } catch APIError.invalidResponse {
            #expect(true)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Request throws HTTP status code error")
    func requestThrowsHTTPStatusCodeError() async throws {
        let client = makeClient()
        let errorData = Data(#"{"status_message":"Unauthorized"}"#.utf8)
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 401)
            return (response, errorData)
        }

        do {
            let _: DecodableResponse = try await client.request(Endpoint(path: "/authentication/token/new"))
            Issue.record("Expected HTTP status code error")
        } catch APIError.httpStatusCode(let statusCode, let data) {
            #expect(statusCode == 401)
            #expect(data == errorData)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Request throws decoding failed error")
    func requestThrowsDecodingFailedError() async throws {
        let client = makeClient()
        URLProtocolMock.requestHandler = { request in
            let response = try makeHTTPResponse(for: request, statusCode: 200)
            return (response, Data(#"{"wrong_key":"token"}"#.utf8))
        }

        do {
            let _: DecodableResponse = try await client.request(Endpoint(path: "/authentication/token/new"))
            Issue.record("Expected decoding failed error")
        } catch APIError.decodingFailed {
            #expect(true)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Request wraps transport error")
    func requestWrapsTransportError() async throws {
        let client = makeClient()
        URLProtocolMock.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        do {
            let _: DecodableResponse = try await client.request(Endpoint(path: "/authentication/token/new"))
            Issue.record("Expected underlying transport error")
        } catch APIError.underlying(let error) {
            #expect((error as? URLError)?.code == .notConnectedToInternet)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private extension NetworkClientSuite {
    func makeClient(token: String = "token") -> NetworkClient {
        URLProtocolMock.reset()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]

        return NetworkClient(
            configuration: TMDBConfiguration(
                baseURL: URL(string: "https://api.test.themoviedb.org/3")!,
                readAccessToken: token
            ),
            session: URLSession(configuration: configuration)
        )
    }
}

private struct DecodableResponse: Decodable, Equatable {
    let requestToken: String
}

private struct SessionResponse: Decodable, Equatable {
    let sessionId: String
}

private func makeURL(for request: URLRequest) throws -> URL {
    guard let url = request.url else {
        throw URLError(.badURL)
    }
    return url
}

private func makeHTTPResponse(
    for request: URLRequest,
    statusCode: Int
) throws -> HTTPURLResponse {
    guard let response = HTTPURLResponse(
        url: try makeURL(for: request),
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil
    ) else {
        throw URLError(.badServerResponse)
    }
    return response
}

private extension URLRequest {
    func httpBodyData() -> Data? {
        if let httpBody {
            return httpBody
        }

        guard let stream = httpBodyStream else {
            return nil
        }

        stream.open()
        defer { stream.close() }

        var data = Data()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }

        while stream.hasBytesAvailable {
            let count = stream.read(buffer, maxLength: bufferSize)
            if count < 0 {
                return nil
            }
            if count == 0 {
                break
            }
            data.append(buffer, count: count)
        }

        return data
    }
}
