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
