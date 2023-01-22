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
        tmdb.dateFormat = "YYYY-mm-dd"
        return tmdb
    }()
}

extension JSONDecoder {
    static let tmdb: JSONDecoder = {
        let tmdb = JSONDecoder()
        tmdb.keyDecodingStrategy = .convertFromSnakeCase
        tmdb.dateDecodingStrategy = .formatted(.tmdb)
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
