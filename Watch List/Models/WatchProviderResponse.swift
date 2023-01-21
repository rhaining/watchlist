//
//  WatchProviderResponse.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation

struct WatchProviderResponse: Decodable {
    let id: Int?
    let results: [String: WatchProviderRegion]?
}
