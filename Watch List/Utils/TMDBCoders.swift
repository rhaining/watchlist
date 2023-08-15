//
//  TMDBDecoder.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/22/23.
//

import Foundation

extension DateFormatter {
    static let tmdb: DateFormatter = {
        let tmdb = DateFormatter()
        tmdb.dateFormat = "yyyy-MM-dd"
        return tmdb
    }()
    static let fullDate: DateFormatter = {
        let fullDate = DateFormatter()
        fullDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'" // 2023-06-16T23:51:55.000Z
        return fullDate
    }()
}

extension JSONDecoder {
    static let tmdb: JSONDecoder = {
        let tmdb = JSONDecoder()
        tmdb.keyDecodingStrategy = .convertFromSnakeCase
        tmdb.dateDecodingStrategy = .formatted(.tmdb)
        return tmdb
    }()
    static let tmdbWithFullDate: JSONDecoder = {
        let tmdb = JSONDecoder()
        tmdb.keyDecodingStrategy = .convertFromSnakeCase
        tmdb.dateDecodingStrategy = .formatted(.fullDate)
        return tmdb
    }()
}

extension JSONEncoder {
    static let tmdb: JSONEncoder = {
        let tmdb = JSONEncoder()
        tmdb.keyEncodingStrategy = .convertToSnakeCase
        tmdb.dateEncodingStrategy = .formatted(.tmdb)
        return tmdb
    }()
}

extension DateComponentsFormatter {
    static let tmdb: DateComponentsFormatter = {
        let tmdb = DateComponentsFormatter()
        tmdb.allowedUnits = [.hour, .minute]
        tmdb.unitsStyle = .positional
        tmdb.zeroFormattingBehavior = .pad
        return tmdb
    }()
    
    func movieTime(from: TimeInterval) -> String? {
        return movieTime(from: Int(from))
    }
    func movieTime(from: Int?) -> String? {
        guard let from = from, var movieTime = string(from: TimeInterval(from * 60)) else { return nil }
        if movieTime.starts(with: "0") {
            movieTime.removeFirst()
        }
        return movieTime
    }
}
