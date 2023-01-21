//
//  Media.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation

struct Media: Codable, Identifiable, Equatable{
    let poster_path: String?
    var posterUrl: URL? {
        guard let posterPath = poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)") else { return nil }
        
        return url
    }
    var thumbnailUrl: URL? {
        guard let posterPath = poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)") else { return nil }
        
        return url
    }
    
    let backdrop_path: String?
    var backdropUrl: URL? {
        guard let backdropPath = backdrop_path, let url = URL(string: "https://image.tmdb.org/t/p/w300\(backdropPath)") else { return nil }
        
        return url
    }

    let id: Int
    let media_type: String
    let title: String?
    let name: String?
    let overview: String?
    
    let release_date: String?
    let first_air_date: String?
    var year: String? {
        if let year = release_date?.prefix(4) {
            return String(year)
        } else if let year = first_air_date?.prefix(4) {
            return String(year)
        } else {
            return nil
        }
    }
    var watchedAt: Date?
}

extension Media {
    static func == (lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id
    }
}
