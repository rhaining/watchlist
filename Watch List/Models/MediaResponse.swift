//
//  MediaResponse.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation

struct MediaResponse: Codable {
    let page: Int
    let results: [Media]
}
