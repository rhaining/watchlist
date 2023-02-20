//
//  String~SeasonEpisode.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import Foundation

extension String {
    static func episodeDescriptor(season: Int?, episode: Int?) -> String {
        var buffer = ""
        if let season = season {
            buffer += "S" + String(format: "%02d", season)
        }
        if let episode = episode {
            buffer += "E" + String(format: "%02d", episode)
        }
        return buffer.count > 0 ? buffer : "-"
    }
}
