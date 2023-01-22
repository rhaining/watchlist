//
//  MediaState.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/19/23.
//

import Foundation

enum MediaState: CaseIterable {
    case shortlist
    case watchlist
    case watched
}

extension MediaState {
    var title: String {
        switch self {
            case .shortlist:
                return "Short list"
            
            case .watchlist:
                return "Watchlist"
                
            case .watched:
                return "Watched"
        }
    }
    
    var imageName: String {
        switch self {
            case .shortlist:
                return "bolt"
            
            case .watchlist:
                return "tv"
                
            case .watched:
                return "checkmark"
        }
    }
}
