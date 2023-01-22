//
//  Media.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation


struct Media: Codable, Identifiable, Equatable, Hashable {
    let posterPath: String?
    var posterUrl: URL? {
        guard let posterPath = posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)") else { return nil }
        
        return url
    }
    var thumbnailUrl: URL? {
        guard let posterPath = posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)") else { return nil }
        
        return url
    }
    
    let backdropPath: String?
    var backdropUrl: URL? {
        guard let backdropPath = backdropPath, let url = URL(string: "https://image.tmdb.org/t/p/w300\(backdropPath)") else { return nil }
        
        return url
    }

    let id: Int
    let mediaType: MediaType
    let title: String?
    let name: String?
    let overview: String?
    
    let releaseDate: String?
    let firstAirDate: String?
    var year: String? {
        if let dateStr = releaseDate ?? firstAirDate,
           dateStr.count > 0,
           let date = DateFormatter.tmdb.date(from: dateStr),
           let year = Calendar.current.dateComponents([.year], from: date).year {
            return String(year)
        } else {
            return nil
        }
    }
    
    var watchedAt: Date?
}

extension Media {
    static func == (lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Media {
    static let previewGodfather = Media(posterPath: "/vDGr1YdrlfbU9wxTOdpf3zChmv9.jpg",backdropPath: nil, id: 238, mediaType: .movie, title: "The Godfather", name: nil, overview: "lorem ipsum", releaseDate: "2020-10-20", firstAirDate: nil)
    
    static let previewGodfatherLong =  Media(posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: nil, id: 238, mediaType: .movie, title: "The Godfather", name: nil, overview: "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and Winston or anybody else is in there, you the first motherfucker to get shot. You understand?", releaseDate: "1895-10-20", firstAirDate: nil)
    
    static let previewWonderYears = Media(posterPath: "/tGmCxGkVMOqig2TrbXAsE9dOVvX.jpg", backdropPath: nil, id: 238, mediaType: .tv, title: nil, name: "Wonder years", overview: "lorem ipsum", releaseDate: nil, firstAirDate: "2015-05-20")
}
