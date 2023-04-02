//
//  TmdbApi.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import Foundation

struct TmdbApi {
    static let host = "api.themoviedb.org"
    static let apiVersion = 3
    
    static func loadSeason(tvShow: Media, seasonNumber: Int?, completion: @escaping (Result<TVSeasonDetails, Error>) -> Void) {
        guard let seasonNumber = seasonNumber else { return }
        let urlStr = "https://\(host)/\(apiVersion)/\(tvShow.mediaType.rawValue)/\(tvShow.id)/season/\(seasonNumber)?api_key=\(Constants.apiKey)"
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url);
            URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                
                if let httpReponse = response as? HTTPURLResponse, httpReponse.statusCode == 404 {
                    completion(.failure(TmdbError.seasonNotFound))
                    return
                }
                
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
