//
//  Storage.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation

final class Storage: ObservableObject {
    static let shared = Storage()

    @Published var watchlist: [Media] = []
    @Published var watchedMedia: [Media] = []
    private var watchlistURL: URL? {
        return fileURL(for: "watchlist.json")
    }
    private var watchedURL: URL? {
        return fileURL(for: "watched.json")
    }
    private func fileURL(for fileName: String) -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            NSLog("can't find directory")
            return nil
        }
        return dir.appendingPathComponent(fileName)
    }

    private init() {
        moveFavesToWatchlist()
        readFromFile()
    }
    
    //        can remove this later:
    private func moveFavesToWatchlist() {
        guard let favesUrl = fileURL(for: "faves.json"), let watchlistURL = watchlistURL else { return }
        do {
            try FileManager.default.moveItem(at: favesUrl, to: watchlistURL)
        } catch {
            NSLog("move exception \(error)")
        }
    }
    
    private func readFromFile() {
        guard let watchlistURL = watchlistURL, let watchedURL = watchedURL else { return }
            
        do {
            let data = try Data(contentsOf: watchlistURL, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([Media].self, from: data)
            self.watchlist = jsonData
        } catch {
            NSLog("Unable to read from file \(error)")
        }
        
        do {
            let data = try Data(contentsOf: watchedURL, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([Media].self, from: data)
            self.watchedMedia = jsonData
        } catch {
            NSLog("Unable to read from file \(error)")
        }
    }
    
    private func save(fileUrl: URL?, media: [Media]) {
        guard let fileUrl = fileUrl else { return }

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(media)
            try jsonData.write(to: fileUrl)
        } catch {
            NSLog("Unable to save \(error)")
        }
    }
    
    private func save() {
        save(fileUrl: watchlistURL, media: watchlist);
        save(fileUrl: watchedURL, media: watchedMedia);
    }
    
    func isOnWatchlist(_ media: Media) -> Bool {
        return watchlist.contains(media)
    }
    
    func isWatched(_ media: Media) -> Bool {
        return watchedMedia.contains(media)
    }
    
    func addToWatchlist(_ newMedia: Media) {
        watchlist.insert(newMedia, at: 0)
        save()
    }
    
    func remove(_ oldMedia: Media) {
        watchlist.removeAll { m in
            return oldMedia == m
        }
        watchedMedia.removeAll { m in
            return oldMedia == m
        }
        save()
    }
    func deleteFromWatchlist(indexSet: IndexSet) {
        watchlist.remove(atOffsets: indexSet)
        save()
    }
    func deleteFromWatched(indexSet: IndexSet) {
        watchedMedia.remove(atOffsets: indexSet)
        save()
    }
    
    func moveWithinWatchlist(from source: IndexSet, to destination: Int) {
        watchlist.move(fromOffsets: source, toOffset: destination)
        save()
    }
    
    func markAsWatched(_ media: Media) {
        remove(media)
        
        var copyMedia = media
        copyMedia.watchedAt = Date()
        watchedMedia.insert(copyMedia, at: 0)
        
        save()
    }
    
    func moveToWatchlist(_ media: Media) {
        remove(media)
        watchlist.insert(media, at: 0)
        save()
    }
}
