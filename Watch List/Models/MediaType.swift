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
