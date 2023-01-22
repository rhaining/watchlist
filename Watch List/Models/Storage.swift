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
        readFromDisk()
    }
    
    //        can remove this later:
    private func moveFavesToWatchlist() {
        guard let favesUrl = fileURL(for: "faves.json"), FileManager.default.fileExists(atPath: favesUrl.absoluteString), let watchlistURL = watchlistURL else { return }
        do {
            try FileManager.default.moveItem(at: favesUrl, to: watchlistURL)
        } catch {
            NSLog("move exception \(error)")
        }
    }
    
    private func readFromDisk() {
        guard let watchlistURL = watchlistURL, let watchedURL = watchedURL else { return }

        self.watchlist = readFrom(fileUrl: watchlistURL)
        self.watchedMedia = readFrom(fileUrl: watchedURL)
    }
    
    private func readFrom(fileUrl: URL) -> [Media] {
        do {
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            let jsonData = try JSONDecoder.tmdb.decode([Media].self, from: data)
            return jsonData
        } catch {
            NSLog("Unable to read from file \(error)")
            return []
        }
    }
    
    private func save(fileUrl: URL?, media: [Media]) {
        guard let fileUrl = fileUrl else { return }

        do {
            let jsonData = try JSONEncoder.tmdb.encode(media)
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
