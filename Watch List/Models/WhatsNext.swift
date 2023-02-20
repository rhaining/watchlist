//
//  WhatsNext.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import Foundation

struct WhatsNext: Codable, Identifiable {
    let media: Media
    var id: Int? { return media.id }
    let tvEp: TVEpisode?
    let movieProgress: Int?
    let updatedAt: Date
    
    init(tvShow: Media, tvEp: TVEpisode) {
        self.media = tvShow
        self.tvEp = tvEp
        self.movieProgress = nil
        self.updatedAt = Date()
    }
    
    init(movie: Media, movieProgress: Int) {
        self.media = movie
        self.tvEp = nil
        self.movieProgress = movieProgress
        self.updatedAt = Date()
    }
}

extension WhatsNext: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(media.mediaType)
        hasher.combine(media.id)
    }
}

extension WhatsNext: Equatable {
    static func == (lhs: WhatsNext, rhs: WhatsNext) -> Bool {
        return lhs.media.mediaType == rhs.media.mediaType && lhs.media.id == rhs.media.id
    }
}

