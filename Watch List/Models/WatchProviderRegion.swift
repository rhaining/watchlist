//
//  WatchProviderRegion.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation

struct WatchProviderRegion: Decodable {
    let link: String?
    let flatrate: [WatchProvider]?
    let rent: [WatchProvider]?
    let buy: [WatchProvider]?
}
