//
//  PersonCreditsResponse.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 4/29/23.
//

import Foundation

struct PersonCreditsResponse: Codable {
    let id: Int
    let cast: [Media]
    let crew: [Media]
}
