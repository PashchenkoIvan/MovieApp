//
//  EndpointSuite.swift
//  MovieAppTests
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation
import Testing

@testable import MovieApp

@Suite("Endpoint")
struct EndpointSuite {
    @Test("Init uses GET and empty optional request parts by default")
    func initUsesDefaults() {
        let endpoint = Endpoint(path: "/movie/popular")

        #expect(endpoint.path == "/movie/popular")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty)
        #expect(endpoint.headers.isEmpty)
        #expect(endpoint.body == nil)
    }

    @Test("Init stores custom request parts")
    func initStoresCustomRequestParts() {
        let body = Data(#"{"name":"value"}"#.utf8)
        let queryItems = [URLQueryItem(name: "page", value: "2")]
        let headers = ["X-Test": "value"]

        let endpoint = Endpoint(
            path: "/movie/1",
            method: .put,
            queryItems: queryItems,
            headers: headers,
            body: body
        )

        #expect(endpoint.path == "/movie/1")
        #expect(endpoint.method == .put)
        #expect(endpoint.queryItems == queryItems)
        #expect(endpoint.headers == headers)
        #expect(endpoint.body == body)
    }

    @Test("HTTP method raw values match API verbs")
    func httpMethodRawValuesMatchAPIVerbs() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
        #expect(HTTPMethod.put.rawValue == "PUT")
        #expect(HTTPMethod.delete.rawValue == "DELETE")
    }
}
