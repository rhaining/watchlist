//
//  MediaState.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/19/23.
//

import Foundation

enum MediaState: CaseIterable {
    case watchlist
    case watched
}

extension MediaState {
    var title: String {
        switch self {
            case .watchlist:
                return "Watchlist"
                
            case .watched:
                return "Watched"
        }
    }
    
    var imageName: String {
        switch self {
            case .watchlist:
                return "tv"
                
            case .watched:
                return "checkmark"
        }
    }
}
