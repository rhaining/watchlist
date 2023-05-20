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
    let viewMedia: (Media) -> Void;
    @State private var mediaTypeFilter: MediaType = .all
    @ObservedObject private var storage = Storage.shared
    @State private var randomize = false
    
    
    init(mediaState: MediaState, viewMedia: @escaping (Media) -> Void) {
        self.mediaState = mediaState
        self.viewMedia = viewMedia
        staticMediaList = nil
    }
    
//    For internal preview purposes
    fileprivate init(list: [Media]) {
        mediaState = .watchlist
        viewMedia = {(m) in}
        staticMediaList = list
    }
    private var staticMediaList: [Media]? = nil
    
    private var mediaList: [Media] {
        if let staticMediaList = staticMediaList { return staticMediaList }
        
        return storage.mediaList(for: mediaState)
    }
    
    private var canMoveItems: Bool {
        return mediaState == .watchlist
    }
    
    private var filteredMedia: [Media] {
        return mediaList.filter({ m in
            switch mediaTypeFilter {
                case .all:
                    return true
                case .movie, .tv:
                    return m.mediaType == mediaTypeFilter
                case .person:
                    return false
            }
        })
    }
        
    var body: some View {
        List {
            if mediaList.count == 0 {
                Text("No items found.")
                    .padding()
            } else {
                if mediaState == .watchlist {
                    WhatsNextView()
                }
                
                HStack {
                    Picker("Filter", selection: $mediaTypeFilter) {
                        Text("All").tag(MediaType.all)
                        Text("Movie").tag(MediaType.movie)
                        Text("TV").tag(MediaType.tv)
                    }
                    .pickerStyle(.segmented)
                    
                    Button(action: { randomize = true }) {
                        Image(systemName: "wand.and.stars")
                    }
                }
                ForEach(filteredMedia, id: \.id){ m in
                    NavigationLink(value: m) {
                        MediaListRow(media: m, mediaState: mediaState)
                            .contextMenu {
                                Button(action: {
                                    Task.init {
                                        await Storage.shared.move(media: m, to: .watched)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: MediaState.watched.imageName)
                                        Text("Mark as watched")
                                            .font(.system(size: 18))
                                    }
                                }
                            }
                    }

                }
                .onMove(perform: canMoveItems ? { source, destination in
                    Task.init {
                        await storage.moveWithinList(mediaState: mediaState, from: source, to: destination)
                    }
                } : nil)
                .onDelete { source in
                    Task.init {
                        await storage.delete(from: mediaState, indexSet: source)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Media.self) { m in
            MediaView(media: m)

        }
        .navigationTitle(mediaState.title)
        .navigationBarItems(leading: Image(systemName: mediaState.imageName), trailing: Text("\(mediaList.count) saved"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .disabled(mediaList.count == 0)
            }
        }
        .sheet(isPresented: $randomize) {
            RandomizerView(mediaList: filteredMedia) { media in
                guard let media = media else { return }
                
                viewMedia(media)
                randomize = false
            }
        }
    }
    
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MediaListView(list: [ .previewGodfather ])
        }
        NavigationStack {
            MediaListView(mediaState: .watchlist) {(m) in}
        }
        NavigationStack {
            MediaListView(mediaState: .watched) {(m) in}
        }
    }
}
