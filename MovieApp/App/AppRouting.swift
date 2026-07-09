//
//  AppRouting.swift
//  MovieApp
//
//  Created by Ivan P. on 09/07/2026.
//

import Foundation

protocol RootRouting: AnyObject {
    func openMain()
    func openLogin()
}

protocol LoginRouting: AnyObject {
    func openMain()
}

protocol MainRouting: AnyObject {
    func openMovieDetails(_ movieId: UUID)
}
