//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import Foundation

@MainActor
final class HomeViewModel: BaseViewModel<HomeViewState> {
    private let loadHomeMoviesUseCase: LoadHomeMoviesUseCase
    private var loadTask: Task<Void, Never>?

    init(loadHomeMoviesUseCase: LoadHomeMoviesUseCase) {
        self.loadHomeMoviesUseCase = loadHomeMoviesUseCase
        super.init(initialState: .idle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadHomeMoviesIfNeeded()
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        loadTask?.cancel()
    }

    func retry() {
        loadHomeMovies()
    }

    private func loadHomeMoviesIfNeeded() {
        guard state == .idle else { return }
        loadHomeMovies()
    }

    private func loadHomeMovies() {
        loadTask?.cancel()
        setState(.loading)

        loadTask = Task { [weak self, loadHomeMoviesUseCase] in
            do {
                let homeMovies = try await loadHomeMoviesUseCase.execute()
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self?.setState(homeMovies.isEmpty ? .empty : .content(homeMovies))
                }
            } catch {
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self?.setState(.failed(message: error.localizedDescription))
                }
            }
        }
    }
}

final class PreviewLoadHomeMoviesUseCase: LoadHomeMoviesUseCase {
    func execute() async throws -> HomeMovies {
        let featured = Movie(
            id: 1,
            title: "The Grand Meridian",
            overview: "A precise, atmospheric thriller about an archivist tracing a vanished film through the hidden rooms of a coastal cinema.",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2026-10-02",
            voteAverage: 8.7,
            popularity: 182.4
        )

        return HomeMovies(
            featured: featured,
            trailers: [
                MovieTrailer(
                    id: "preview-trailer",
                    movieID: featured.id,
                    movieTitle: featured.title,
                    name: "Official Trailer",
                    key: "dQw4w9WgXcQ",
                    site: "YouTube",
                    type: "Trailer",
                    isOfficial: true
                )
            ],
            popular: [
                Movie(id: 2, title: "Night Signal", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "2026-06-12", voteAverage: 8.1, popularity: 144),
                Movie(id: 3, title: "Glass Harbor", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "2026-03-19", voteAverage: 7.8, popularity: 129),
                Movie(id: 4, title: "After the Overture", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "2025-11-21", voteAverage: 8.4, popularity: 121)
            ],
            topRated: [
                Movie(id: 5, title: "The Last Projection", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "2024-09-07", voteAverage: 9.0, popularity: 98),
                Movie(id: 6, title: "Silent Marquee", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "2023-12-14", voteAverage: 8.8, popularity: 87)
            ],
            upcoming: [
                Movie(id: 7, title: "City of Reels", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "2026-12-18", voteAverage: 0, popularity: 76),
                Movie(id: 8, title: "Velvet Frame", overview: "", posterPath: nil, backdropPath: nil, releaseDate: "2027-01-09", voteAverage: 0, popularity: 64)
            ]
        )
    }
}
