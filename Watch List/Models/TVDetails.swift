//
//  TVDetails.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/1/23.
//

import Foundation

struct TVDetails: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let seasons: [TVSeason]?
}
extension TVDetails {
    static func == (lhs: TVDetails, rhs: TVDetails) -> Bool {
        return lhs.id == rhs.id
    }
}
