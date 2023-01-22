//
//  WatchProvider.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation

struct WatchProvider: Decodable {
    let logoPath: String?
    let providerId: Int?
    let displayPriority: Int?
    let providerName: String?
    
    var logoUrl: URL? {
        guard let logoPath = logoPath, let url = URL(string: "https://image.tmdb.org/t/p/w92\(logoPath)") else { return nil }
        
        return url
    }
}

extension WatchProvider {
    static let previewNetflix = WatchProvider(logoPath: nil, providerId: 1, displayPriority: 1, providerName: "Netflix")
}
