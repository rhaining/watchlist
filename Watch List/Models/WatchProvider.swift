//
//  WatchProvider.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation

struct WatchProvider: Decodable {
    let logo_path: String?
    let provider_id: Int?
    let display_priority: Int?
    let provider_name: String?
    
    var logoUrl: URL? {
        guard let logo_path = logo_path, let url = URL(string: "https://image.tmdb.org/t/p/w92\(logo_path)") else { return nil }
        
        return url
    }
}
