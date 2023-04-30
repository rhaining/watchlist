//
//  WhatsNextHelper.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 4/30/23.
//

import Foundation

struct WhatsNextHelper {
    private let storage = Storage.shared
    
    func markAsWatched(media: Media) {
        switch media.mediaType {
            case .tv:
                markNextEpisodeAsWhatsNext(media: media)
                
            case .movie:
                Task.init {
                    await storage.move(media: media, to: .watched)
                }
            
            case .person, .all:
                NSLog("Should not be here.")
        }
    }

    private func markNextEpisodeAsWhatsNext(media: Media) {
        guard let tvEp = storage.getNextEpisode(tvShow: media),
              let seasonNumber = tvEp.seasonNumber else { return }
        
        TmdbApi.loadSeason(tvShow: media, seasonNumber: seasonNumber) { result in
            switch result {
                case .success(let seasonDetails):
                    if let episodes = seasonDetails.episodes,
                       let idx = episodes.firstIndex(of: tvEp){
                        if Int(idx) + 1 < episodes.count {
                            let newTvEp = episodes[Int(idx)+1]
                            Task.init {
                                await storage.addToWhatsNext(tvShow: media, episode: newTvEp)
                            }
                        } else {
                            TmdbApi.loadSeason(tvShow: media, seasonNumber: seasonNumber+1) { result in
                                switch result {
                                    case .success(let seasonDetails):
                                        if let episodes = seasonDetails.episodes,
                                           let newTvEp = episodes.first {
                                            Task.init {
                                                await storage.addToWhatsNext(tvShow: media, episode: newTvEp)
                                            }
                                        }
                                        
                                    case .failure(let error):
                                        if let tmdbError = error as? TmdbError, tmdbError == .seasonNotFound {
                                            Task.init {
                                                await storage.removeFromWhatsNext(media: media)
                                            }
                                        } else {
                                            NSLog("unknown error \(error)")
                                        }
                                }
                            }
                        }
                    }
                    
                case .failure(_):
                    break
            }
        }
    }

}
