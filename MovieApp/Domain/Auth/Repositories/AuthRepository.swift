//
//  AuthRepository.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

protocol AuthRepository {
    func login(username: String, password: String) async throws -> AuthSession
}
