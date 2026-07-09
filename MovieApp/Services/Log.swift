//
//  Log.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

enum RoutingType {
    case present
    case push
    case set
}

enum Screens: String {
    case main = "Main"
    case login = "Login"
    case root = "Root"
}

final class LogService {
    let screen: Screens?
    
    init(screen: Screens? = nil) {
        self.screen = screen
    }
    
    func screenLog(_ message: String) {
        guard let screen else {
            print("| uknown screen || \(message) |")
            return
        }
        print("| \(screen) || \(message) |")
    }
    
    func routingLog(from: Screens, to: Screens, type: RoutingType = .push) {
        print("\(from) --> \(to) || Routing type: \(type)")
    }
}
