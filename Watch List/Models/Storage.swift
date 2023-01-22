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
    @Published var shortlist: [Media] = []
    @Published var watchedMedia: [Media] = []
    
    private var shortlistURL: URL {
        return fileURL(for: "shortlist.json")!
    }
    private var watchlistURL: URL {
        return fileURL(for: "watchlist.json")!
    }
    private var watchedURL: URL {
        return fileURL(for: "watched.json")!
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
        guard let favesUrl = fileURL(for: "faves.json"), FileManager.default.fileExists(atPath: favesUrl.absoluteString) else { return }
        do {
            try FileManager.default.moveItem(at: favesUrl, to: watchlistURL)
        } catch {
            NSLog("move exception \(error)")
        }
    }
    
    private func readFromDisk() {
        self.shortlist = readFrom(fileUrl: shortlistURL)
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
    
    private func save(fileUrl: URL, media: [Media]) {
        do {
            let jsonData = try JSONEncoder.tmdb.encode(media)
            try jsonData.write(to: fileUrl)
        } catch {
            NSLog("Unable to save \(error)")
        }
    }
    
    private func save() {
        save(fileUrl: shortlistURL, media: shortlist);
        save(fileUrl: watchlistURL, media: watchlist);
        save(fileUrl: watchedURL, media: watchedMedia);
    }
    
    func mediaList(for mediaState: MediaState) -> [Media] {
        let mediaList: [Media]
        switch mediaState {
            case .shortlist:
                mediaList = shortlist
            case .watchlist:
                mediaList = watchlist
            case .watched:
                mediaList = watchedMedia
        }
        return mediaList
    }
    
    func set(mediaList: [Media], for mediaState: MediaState) {
        switch mediaState {
            case .shortlist:
                shortlist = mediaList
            case .watchlist:
                watchlist = mediaList
            case .watched:
                watchedMedia = mediaList
        }
    }
    
    func isOnList(_ mediaState: MediaState, media: Media) -> Bool {
        return mediaList(for: mediaState).contains(media)
    }
    
    
    func remove(_ oldMedia: Media) {
        shortlist.removeAll { m in
            return oldMedia == m
        }
        watchlist.removeAll { m in
            return oldMedia == m
        }
        watchedMedia.removeAll { m in
            return oldMedia == m
        }
        save()
    }
    
    func delete(from mediaState: MediaState, indexSet: IndexSet) {
        var mediaList = mediaList(for: mediaState)
        mediaList.remove(atOffsets: indexSet)
        set(mediaList: mediaList, for: mediaState)
        save()
    }
    
    func moveWithinList(mediaState: MediaState, from source: IndexSet, to destination: Int) {
        var mediaList = mediaList(for: mediaState)
        mediaList.move(fromOffsets: source, toOffset: destination)
        set(mediaList: mediaList, for: mediaState)
        save()
    }
   
    func move(media: Media, to mediaState: MediaState) {
        remove(media)
        
        var copyMedia = media
        if mediaState == .watched {
            copyMedia.watchedAt = Date()
        }
        
        var mediaList = mediaList(for: mediaState)
        mediaList.insert(copyMedia, at: 0)
        set(mediaList: mediaList, for: mediaState)
        save()
    }

}
