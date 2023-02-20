//
//  TmdbApi.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import Foundation

struct TmdbApi {
    static func loadSeason(tvShow: Media, seasonNumber: Int?, completion: @escaping (Result<TVSeasonDetails, Error>) -> Void) {
        guard let seasonNumber = seasonNumber else { return }
        let urlStr = "https://api.themoviedb.org/3/\(tvShow.mediaType.rawValue)/\(tvShow.id)/season/\(seasonNumber)?api_key=\(Constants.apiKey)"
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url);
            URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let seasonDetails = try JSONDecoder.tmdb.decode(TVSeasonDetails.self, from: data)
                    completion(.success(seasonDetails))
                } catch {
                    NSLog("loadDetails error \(error)")
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
