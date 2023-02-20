//
//  TVSeasonDetails.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/8/23.
//

import Foundation

struct TVSeasonDetails: Codable, Identifiable, Equatable {
    let airDate: Date?
    let episodes: [TVEpisode]?
    let name: String?
    let overview: String?
    let id: Int?
    let posterPath: String?
    let seasonNumber: Int?
    
    var originalPosterUrl: URL? {
        guard let posterPath = posterPath else { return nil }
        
        return URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")
    }
    var posterUrl: URL? {
        guard let posterPath = posterPath else { return nil }
        
        return URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)")
    }
}
extension TVSeasonDetails {
    static func == (lhs: TVSeasonDetails, rhs: TVSeasonDetails) -> Bool {
        return lhs.id == rhs.id
    }
}
extension TVSeasonDetails {
    static let communityOne = TVSeasonDetails(airDate: Date(timeIntervalSince1970: 3049324), episodes: [.communityOne], name: "Community One", overview: "This is an overview", id: 10, posterPath: "/vDGr1YdrlfbU9wxTOdpf3zChmv9.jpg", seasonNumber: 1)
}
