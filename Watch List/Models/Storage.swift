//
//  Storage.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import Foundation

@globalActor actor MyGlobalActor {
    static let shared = MyGlobalActor()
}

final class Storage: ObservableObject {
    static let shared = Storage()

    @Published var watchlist: [Media] = []
    @Published var watchedMedia: [Media] = []
    @Published var whatsNext: [WhatsNext] = []
    
    private var watchlistURL: URL {
        return fileURL(for: "watchlist.json")!
    }
    private var watchedURL: URL {
        return fileURL(for: "watched.json")!
    }
    private var tvWhatsNextURL: URL {
        return fileURL(for: "whats_next.json")!
    }

    private func fileURL(for fileName: String) -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            NSLog("can't find directory")
            return nil
        }
        return dir.appendingPathComponent(fileName)
    }

    private init() {
        readFromDisk()
    }
    
    /**
     File Tasks
     */
    private func readFromDisk() {
        do {
            watchlist = try readFrom(fileUrl: watchlistURL, type: [Media].self)
        } catch {
            NSLog("Error reading watchlist \(error)")
        }
        do {
            whatsNext = try readFrom(fileUrl: tvWhatsNextURL, type: [WhatsNext].self)
        } catch {
            NSLog("Error reading tv whats next list \(error)")
        }
        do {
            watchedMedia = try readFrom(fileUrl: watchedURL, type: [Media].self)
        } catch {
            NSLog("Error reading watched media \(error)")
        }
    }

    private func readFrom<T>(fileUrl: URL, type: T.Type) throws -> T where T : Decodable {
        let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
        let jsonData = try JSONDecoder.tmdb.decode(type, from: data)
        return jsonData
    }
    
    @MyGlobalActor private func save<T>(fileUrl: URL, value: T) where T : Encodable {
        do {
            let jsonData = try JSONEncoder.tmdb.encode(value)
            try jsonData.write(to: fileUrl)
        } catch {
            NSLog("Unable to save \(error)")
        }
    }
    
    @MyGlobalActor private func save() {
        save(fileUrl: watchlistURL, value: watchlist);
        save(fileUrl: watchedURL, value: watchedMedia);
        save(fileUrl: tvWhatsNextURL, value: whatsNext);
    }
    
    
    
    
    
    /**
     READ FUNCTIONS FROM MEDIA LISTS
     */
    func mediaList(for mediaState: MediaState) -> [Media] {
        let mediaList: [Media]
        switch mediaState {
            case .watchlist:
                mediaList = watchlist
            case .watched:
                mediaList = watchedMedia
        }
        return mediaList
    }
    
    func isOnList(_ mediaState: MediaState, media: Media) -> Bool {
        return mediaList(for: mediaState).contains(media)
    }
    
    
    
    
    /**
     WRITE FUNCTIONS TO MEDIA LISTS
     */
    @MainActor private func set(mediaList: [Media], for mediaState: MediaState) {
        switch mediaState {
            case .watchlist:
                watchlist = mediaList
            case .watched:
                watchedMedia = mediaList
        }
    }
    
    @MainActor func remove(_ oldMedia: Media, save: Bool = false) async {
        watchlist.removeAll { m in
            return oldMedia == m
        }
        watchedMedia.removeAll { m in
            return oldMedia == m
        }
        if save {
            await self.save()
        }
    }
    
    func delete(from mediaState: MediaState, indexSet: IndexSet) async {
        var mediaList = mediaList(for: mediaState)
        mediaList.remove(atOffsets: indexSet)
        await set(mediaList: mediaList, for: mediaState)
        await save()
    }
    
    func moveWithinList(mediaState: MediaState, from source: IndexSet, to destination: Int) async {
        var mediaList = mediaList(for: mediaState)
        mediaList.move(fromOffsets: source, toOffset: destination)
        await set(mediaList: mediaList, for: mediaState)
        await save()
    }
   
    func move(media: Media, to mediaState: MediaState) async {
        await remove(media)
        
        var copyMedia = media
        if mediaState == .watched {
            copyMedia.watchedAt = Date()
        }
        
        var mediaList = mediaList(for: mediaState)
        mediaList.insert(copyMedia, at: 0)
        await set(mediaList: mediaList, for: mediaState)
        await save()
    }

    func replace(media: Media, with updatedMedia: Media) async {
        var shouldSave = false
        for mediaState in MediaState.allCases {
            var mediaList = mediaList(for: mediaState)
            if let index = mediaList.firstIndex(of: media) {
                mediaList[index] = updatedMedia
                await set(mediaList: mediaList, for: mediaState)
                shouldSave = true
            }
        }
        if shouldSave {
            await save()
        }
    }
    
    func restoreToFactorySettings() async {
        await set(mediaList: [], for: .watchlist)
        await set(mediaList: [], for: .watched)
        await save()
    }
    
    
    /**
     Watchlist
     */
    
    @MainActor private func set(whatsNext: [WhatsNext]) {
        self.whatsNext = whatsNext
    }
    
    func addToWhatsNext(tvShow: Media, episode: TVEpisode) async {
        var whatsNext = self.whatsNext
        whatsNext.removeAll { wn in
            wn.media == tvShow
        }
        whatsNext.append(WhatsNext(tvShow: tvShow, tvEp: episode))
        await set(whatsNext: whatsNext)
        await save()
    }
    
    func addToWhatsNext(movie: Media, progress: Int) async {
        var whatsNext = self.whatsNext
        whatsNext.removeAll { wn in
            wn.media == movie
        }
        whatsNext.append(WhatsNext(movie: movie, movieProgress: progress))
        await set(whatsNext: whatsNext)
        await save()
    }
    
     func removeFromWhatsNext(media: Media) async {
        var whatsNext = self.whatsNext
        whatsNext.removeAll { wn in
            wn.media == media
        }
        await set(whatsNext: whatsNext)
        await save()
    }
    
    func getNextEpisode(tvShow: Media) -> TVEpisode? {
        guard tvShow.mediaType == .tv else { return nil }
        
        return whatsNext
            .first { wn in
                wn.media == tvShow
            }?
            .tvEp
    }
    
    func getMovieProgress(movie: Media) -> Int? {
        guard movie.mediaType == .movie else { return nil }
        
        return whatsNext
            .first { wn in
                wn.media == movie
            }?
            .movieProgress
    }
}
