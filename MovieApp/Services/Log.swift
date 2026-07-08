//
//  Log.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

enum Screens: String {
    case main = "Main"
    case login = "Login"
    case root = "Root"
}

final class LogService {
    let screen: Screens
    
    init(screen: Screens) {
        self.screen = screen
    }
    
    func screenLog(_ message: String) {
        print("| \(screen) || \(message) |")
    }
}
