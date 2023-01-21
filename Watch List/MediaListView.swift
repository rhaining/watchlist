//
//  MediaListView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/19/23.
//

import SwiftUI

struct MediaListView: View {
    let mediaState: MediaState

    @ObservedObject var storage = Storage.shared    
    
    private var mediaList: [Media] {
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
                ForEach(mediaList, id: \.id){ m in
                    NavigationLink(destination: MediaView(media: m)) {
                        HStack(alignment: .top) {
                            if let thumbnailUrl = m.thumbnailUrl {
                                AsyncImage(url: thumbnailUrl){ image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Color.purple.opacity(0.1)
                                }
                                .frame(width: 100)
                            } else {
                                Color.purple.opacity(0.01)
                                    .frame(width: 100, height: 200)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(m.title ?? m.name ?? "")
                                    .font(.system(size: 20))
                                
                                Text("(\(m.year ?? ""))")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
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
        .navigationTitle(title)
        .navigationBarItems(leading: Image(systemName: headerImgName), trailing: Text("\(mediaList.count) item\(mediaList.count == 1 ? "" : "s")"))
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MediaListView(mediaState: .watchlist)
        }
        MediaListView(mediaState: .watched)
    }
}
