//
//  VideosResponse.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 8/15/23.
//

import Foundation

struct VideosResponse: Decodable {
    let id: Int
    let results: [Video]
}

struct Video: Decodable {
    let iso6391: String?
    let iso31661: String?
    let name: String?
    let key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt: Date?
    let id: String?
}

