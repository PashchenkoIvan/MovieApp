//
//  TMDBAuthDTO.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

struct RequestTokenResponseDTO: Decodable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
}

struct ValidateLoginRequestDTO: Encodable {
    let username: String
    let password: String
    let requestToken: String
}

struct CreateSessionRequestDTO: Encodable {
    let requestToken: String
}

struct CreateSessionResponseDTO: Decodable {
    let success: Bool
    let sessionId: String
}
