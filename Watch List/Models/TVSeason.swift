//
//  TVSeason.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/1/23.
//

import Foundation


struct TVSeason: Codable, Identifiable, Equatable, Hashable {
    let airDate: Date?
    let episodeCount: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int?
}
extension TVSeason {
    static func == (lhs: TVSeason, rhs: TVSeason) -> Bool {
        return lhs.id == rhs.id
    }
}
extension TVSeason {
    static let communityOne = TVSeason(airDate: Date(timeIntervalSince1970: 30413949), episodeCount: 14, id: 129, name: "Community season 1", overview: "this is an overview", posterPath: nil, seasonNumber: 1)
}
