//
//  MovieTrailer.swift
//  MovieApp
//
//  Created by Ivan P. on 22/07/2026.
//

import Foundation

struct MovieTrailer: Identifiable, Hashable, Sendable {
    let id: String
    let movieID: Int
    let movieTitle: String
    let name: String
    let key: String
    let site: String
    let type: String
    let isOfficial: Bool

    var thumbnailURL: URL? {
        guard site.caseInsensitiveCompare("YouTube") == .orderedSame else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }

    var externalURL: URL? {
        guard site.caseInsensitiveCompare("YouTube") == .orderedSame else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}
