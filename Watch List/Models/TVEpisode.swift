//
//  TVEpisode.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import Foundation

struct TVEpisode: Codable, Identifiable, Equatable {
    let airDate: Date?
    let episodeNumber: Int?
    let id: Int?
    let name: String?
    let seasonNumber: Int?
    let stillPath: String?
    
    var stillUrl: URL? {
        guard let stillPath = stillPath else { return nil }
        
        return URL(string: "https://image.tmdb.org/t/p/w300\(stillPath)")
    }
}
extension TVEpisode {
    static func == (lhs: TVEpisode, rhs: TVEpisode) -> Bool {
        return lhs.id == rhs.id
    }
}
extension TVEpisode {
    static let communityOne = TVEpisode(airDate: Date(timeIntervalSince1970: 3924304), episodeNumber: 1, id: 1001, name: "Episode one1one", seasonNumber: 1, stillPath: "/3j10k0OIY2yRhguiyEEDdNnTRw9.jpg")
}
