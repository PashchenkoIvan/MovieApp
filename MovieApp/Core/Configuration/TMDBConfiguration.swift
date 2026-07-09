//
//  TMDBConfiguration.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

struct TMDBConfiguration {
    let baseURL: URL
    let readAccessToken: String

    static var live: TMDBConfiguration {
        get throws {
            guard
                let token = Bundle.main.object(forInfoDictionaryKey: "TMDBReadAccessToken") as? String,
                !token.isEmpty,
                token != "YOUR_TMDB_READ_ACCESS_TOKEN"
            else {
                throw APIError.missingConfiguration("TMDBReadAccessToken")
            }

            return TMDBConfiguration(
                baseURL: URL(string: "https://api.themoviedb.org/3")!,
                readAccessToken: token
            )
        }
    }
}
