//
//  MovieDetails.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/1/23.
//

import Foundation

struct MovieDetails: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let runtime: Int?
    let imdbId: String?
    
    func readableRuntime() -> String? {
        guard let runtime = runtime else { return nil }
        
        return DateComponentsFormatter.tmdb.movieTime(from: runtime)
    }
}
extension MovieDetails {
    static func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MovieDetails {
    static let taco = MovieDetails(id: 3, runtime: 300, imdbId: nil)
}
