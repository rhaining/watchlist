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
    
    func showCompactOverview() -> Bool {
        if let overview = media.overview {
            return !exposeFullOverview && overview.count > 100;
        } else {
            return !exposeFullOverview
        }
    }
    
    var body: some View {
        ScrollView {
            if let overview = media.overview {
                HStack(alignment: .top) {
                    Button(showCompactOverview() ? "▹" : "▿", action: { exposeFullOverview = !exposeFullOverview })

                    Text(showCompactOverview() ? overview.prefix(100) + "…" : overview)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5)
                    
                    Spacer()
                }
                .onTapGesture { exposeFullOverview = !exposeFullOverview }
                .padding()
            }
            
            VStack(spacing: 10) {
                if let watchedAt = media.watchedAt {
                    Text("Watched on: " + dateFormatter.string(from: watchedAt))
                }
                
                if let mediaState = mediaState {
                    Text("Currently saved to ")
                    + Text("\(Image(systemName: mediaState.imageName)) \(mediaState.title)")
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .shadow(color: .black, radius: 5)
            .padding()

            HStack {
                addToWatchlistButton
                    .disabled(mediaState == .watchlist)
                markAsWatchedButton
                    .disabled(mediaState == .watched)
                removeMediaButton
                    .disabled(mediaState == nil)
            }
            .padding()
            
            ShareLink("Share \(media.mediaType.name)", item: URL(string: "https://www.themoviedb.org/\(media.mediaType.rawValue)/\(media.id)")!)
                .buttonStyle(.bordered)
                .background(Color.white.cornerRadius(10))
                .padding(.bottom)
            
            if let watchProviderRegion = watchProviderRegion {
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

                Text("Source: JustWatch")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .shadow(color: .black, radius: 5)
                    .italic()
                    .padding(.vertical, 10)
            } else {
                Text("Not currently available to stream")
                    .italic()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5)
                    .padding()
            }
            
        }
        .navigationTitle(media.title ?? media.name ?? "")
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarItems(trailing: media.year != nil ? Text("(\(media.year!))") : nil)
        .background{
            if let posterUrl = media.backdropUrl ?? media.posterUrl {
                AsyncImage(url: posterUrl){ image in
                    image
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 4)
                        .overlay(Color.black.opacity(0.6))
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
        .background(Color.white.cornerRadius(10))
    }
    
//    private var moveToWatchlistButton: some View {
//        Button(action: {
//            storage.move(media: media, to: .watchlist)
//            updateMediaState()
//        }) {
//            HStack {
//                Image(systemName: MediaState.watchlist.imageName)
//                Text("Move to watchlist")
//                    .font(.system(size: 14))
//            }
//
//        }
//        .buttonStyle(.bordered)
//        .backgroundStyle(Color.white)
//
//    }
    
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
        .background(Color.white.cornerRadius(10))

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
        .background(Color.white.cornerRadius(10))
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
        NavigationView {
            MediaView(media: .previewGodfatherLong)
        }
        NavigationView {
            MediaView(media: .previewWonderYears)
        }
        NavigationView {
            MediaView(media: .previewGodfather)
        }
    }
}
