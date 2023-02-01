//
//  MediaView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI


struct MediaView: View {
    let media: Media
    @ObservedObject var storage = Storage.shared
    @State private var watchProviderRegion: WatchProviderRegion?
    @State private var exposeFullOverview = false
    @State private var mediaState: MediaState?
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                
                if let posterUrl = media.posterUrl {
                    AsyncImage(url: posterUrl){ image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                    } placeholder: {
                        Color.purple.opacity(0.01)
                    }
                }
                
                Spacer()
            }
            
            if let overview = media.overview {
                HStack(alignment: .top) {
                    if exposeFullOverview || overview.count < 100 {
                        Button("▿", action: { exposeFullOverview = false })
                        Text(media.title ?? media.name ?? "")
                            .fontWeight(.semibold)
                        + Text(media.year != nil ? " (\(media.year!))" : "")
                        + Text(": ")
                        + Text(overview)
                    } else {
                        Button("▹", action: { exposeFullOverview = true  })
                        Text(media.title ?? media.name ?? "")
                            .fontWeight(.semibold)
                        + Text(media.year != nil ? " (\(media.year!))" : "")
                        + Text(": ")
                        + Text(overview.prefix(100) + "…")
                    }
                }
                .onTapGesture { exposeFullOverview = !exposeFullOverview }
                .padding(.horizontal)
            }
            
            if let watchedAt = media.watchedAt {
                Text("Watched on: " + dateFormatter.string(from: watchedAt))
                    .padding()
            }
            
            
            if let mediaState = mediaState {
                Group {
                    Text("Currently saved to ")
                    + Text("\(Image(systemName: mediaState.imageName)) \(mediaState.title)")
                        .fontWeight(.semibold)
                }
                    .padding(.top)
            }

            HStack {
                switch mediaState {
                    case .watchlist:
                        markAsWatchedButton
                        removeMediaButton
                
                    case .watched:
                        moveToWatchlistButton
                        removeMediaButton
                        
                    default:
                        addToWatchlistButton
                        markAsWatchedButton
                }
                
            }
            .padding()
            
            ShareLink("Share \(media.mediaType.name)", item: URL(string: "https://www.themoviedb.org/\(media.mediaType.rawValue)/\(media.id)")!)
            
            if let watchProviderRegion = watchProviderRegion {

                HStack {
                    VStack(alignment: .leading) {
                        if let providers = watchProviderRegion.flatrate {
                            MediaWatchProviderSectionView(title: "Available to stream:", watchProviders: providers)
                        }
                        if let providers = watchProviderRegion.rent {
                            MediaWatchProviderSectionView(title: "Available to rent:", watchProviders: providers)
                        }
                        if let providers = watchProviderRegion.buy {
                            MediaWatchProviderSectionView(title: "Available to buy:", watchProviders: providers)
                        }
                    }
                    Spacer()
                }

                Text("Source: JustWatch")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.top, 10)
            } else {
                Text("Not currently available to stream")
                    .italic()
                    .padding()
            }
            
        }
        .navigationTitle(media.title ?? media.name ?? "")
        .navigationBarItems(trailing: media.year != nil ? Text("\(media.year!)") : nil)
        .background{
            if let posterUrl = media.backdropUrl ?? media.posterUrl {
                AsyncImage(url: posterUrl){ image in
                    image
                        .resizable()
                        .scaledToFill()
                        .opacity(0.10)
                        .blur(radius: 10)
                        .edgesIgnoringSafeArea(.all)
                } placeholder: {
                    Color.purple.opacity(0.01)
                }
            }
        }
        .onAppear(perform: {
            updateMediaState()
            loadWatchProviders()
        })
    }
    
    private func updateMediaState() {
        var newState: MediaState? = nil
        for state in MediaState.allCases {
            if storage.isOnList(state, media: media) {
                newState = state
                break
            }
        }
        mediaState = newState
    }
    
    private var addToWatchlistButton: some View {
        Button(action: {
            storage.move(media: media, to: .watchlist)
            updateMediaState()
        }) {
            HStack {
                Image(systemName: MediaState.watchlist.imageName)
                Text("Save to watch")
                    .font(.system(size: 14))
            }
        }
        .buttonStyle(.bordered)
    }
    
    private var moveToWatchlistButton: some View {
        Button(action: {
            storage.move(media: media, to: .watchlist)
            updateMediaState()
        }) {
            HStack {
                Image(systemName: MediaState.watchlist.imageName)
                Text("Move to watchlist")
                    .font(.system(size: 14))
            }
            
        }
        .buttonStyle(.bordered)
    }
    
    private var markAsWatchedButton: some View {
        Button(action: {
            storage.move(media: media, to: .watched)
            updateMediaState()
        }) {
            HStack {
                Image(systemName: MediaState.watched.imageName)
                Text("Mark watched")
                    .font(.system(size: 14))
            }
            
        }
        .buttonStyle(.bordered)
    }
    
    private var removeMediaButton: some View {
        Button(action: {
            storage.remove(media)
            updateMediaState()
        }) {
            HStack {
                Image(systemName: "trash")
                Text("Remove")
                    .font(.system(size: 14))
            }
            
        }
        .buttonStyle(.bordered)
    }

    
    
    func loadWatchProviders() {
        let urlStr = "https://api.themoviedb.org/3/\(media.mediaType.rawValue)/\(media.id)/watch/providers?api_key=\(Constants.apiKey)"
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url);
            URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let watchProviderReponse = try JSONDecoder.tmdb.decode(WatchProviderResponse.self, from: data)
                    self.watchProviderRegion = watchProviderReponse.results?["US"]
                    
                } catch {
                    NSLog("loadWatchProviders error \(error)")
                }
            }.resume()
        }
    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(media: .previewGodfatherLong)
        MediaView(media: .previewWonderYears)
        MediaView(media: .previewGodfather)
    }
}
