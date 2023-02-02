//
//  MediaDetails.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/1/23.
//

import Foundation

enum MediaDetails: Codable, Identifiable, Equatable, Hashable {
    case tv(TVDetails)
    case movie(MovieDetails)
    
    var id: Int {
        switch self {
            case .tv(let details):
                return details.id
            case .movie(let details):
                return details.id
        }
    }
}
extension MediaDetails {
    static func == (lhs: MediaDetails, rhs: MediaDetails) -> Bool {
        switch lhs {
            case .tv(_):
                switch rhs {
                    case .tv(_):
                        break
                    case .movie(_):
                        return false
                }
                
            case .movie(_):
                switch rhs {
                    case .tv(_):
                        return false
                    case .movie(_):
                        break
                }
        }
        return lhs.id == rhs.id
    }
}
