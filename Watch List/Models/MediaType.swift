//
//  MediaType.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/21/23.
//

import Foundation

enum MediaType: String, Codable, CaseIterable, Identifiable {
    case all
    case movie
    case tv
    case person
    
    var id: String { return rawValue }
}

extension MediaType {
    var name: String {
        switch self {
            case .all:
                return "All"
            case .movie:
                return "Movie"
            case .tv:
                return "TV Show"
            case .person:
                return "Person"
        }
    }
}
