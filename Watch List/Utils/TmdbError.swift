//
//  TmdbError.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 4/2/23.
//

import Foundation

public enum TmdbError: Error {
    case seasonNotFound
}
extension TmdbError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .seasonNotFound:
                return NSLocalizedString("Unable to find the season for this show.", comment: "error")
        }
    }
}
