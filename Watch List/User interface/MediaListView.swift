//
//  MediaListView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/19/23.
//

import SwiftUI



struct MediaListView: View {
    @Environment(\.editMode) var editMode
    
    let mediaState: MediaState
    @State private var mediaTypeFilter: MediaType = .all
    @ObservedObject private var storage = Storage.shared
    
    init(mediaState: MediaState) {
        self.mediaState = mediaState
        staticMediaList = nil
    }
    
//    For internal preview purposes
    fileprivate init(list: [Media]) {
        mediaState = .watchlist
        staticMediaList = list
    }
    private var staticMediaList: [Media]? = nil
    
    private var mediaList: [Media] {
        if let staticMediaList = staticMediaList { return staticMediaList }
        
        switch mediaState {
            case .watchlist:
                return storage.watchlist
                
            case .watched:
                return storage.watchedMedia
        }
    }
    
    private var canMoveItems: Bool {
        return mediaState == .watchlist
    }
    
    var title: String {
        switch mediaState {
            case .watchlist:
                return "Watchlist"
                
            case .watched:
                return "Watched"
        }
    }
    
    var headerImgName: String {
        switch mediaState {
            case .watchlist:
                return "tv"
                
            case .watched:
                return "checkmark"
        }
    }
    
    var body: some View {
        List {
            if mediaList.count == 0 {
                Text("No items found.")
            } else {
                Picker("Filter", selection: $mediaTypeFilter) {
                    Text("All").tag(MediaType.all)
                    Text("Movie").tag(MediaType.movie)
                    Text("TV").tag(MediaType.tv)
                }
                .pickerStyle(.segmented)

                ForEach(mediaList.filter({ m in
                    switch mediaTypeFilter {
                        case .all:
                            return true
                        case .movie, .tv:
                            return m.mediaType == mediaTypeFilter
                        case .person:
                            return false
                    }
                }), id: \.id){ m in
                    NavigationLink(value: m) {
                        MediaListRow(media: m)
                    }
                }
                .onMove(perform: canMoveItems ? { source, destination in
                    storage.moveWithinWatchlist(from: source, to: destination)
                } : nil)
                .onDelete { source in
                    switch mediaState {
                        case .watchlist:
                            storage.deleteFromWatchlist(indexSet: source)
                            
                        case .watched:
                            storage.deleteFromWatched(indexSet: source)
                    }
                }
            }
        }
        .navigationDestination(for: Media.self) { m in
            MediaView(media: m)
        }
        .navigationTitle(title)
        .navigationBarItems(leading: Image(systemName: headerImgName), trailing: Text("\(mediaList.count) item\(mediaList.count == 1 ? "" : "s")"))
        .toolbar {
            EditButton()
                .disabled(mediaList.count == 0)
        }
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MediaListView(list: [ .previewGodfather ])
        }
        NavigationStack {
            MediaListView(mediaState: .watchlist)
        }
        NavigationStack {
            MediaListView(mediaState: .watched)
        }
    }
}
