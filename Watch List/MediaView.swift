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
            
            ShareLink("Share \(media.media_type.rawValue)", item: URL(string: "https://www.themoviedb.org/\(media.media_type.rawValue)/\(media.id)")!)
                .buttonStyle(.bordered)
            
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
        .navigationBarItems(trailing: Text(media.year ?? ""))
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
        if storage.isOnWatchlist(media) {
            mediaState = .watchlist
        } else if storage.isWatched(media) {
            mediaState = .watched
        } else {
            mediaState = nil
        }
    }
    
    private var addToWatchlistButton: some View {
        Button(action: {
            storage.addToWatchlist(media)
            updateMediaState()
        }) {
            HStack {
                Image(systemName: "tv")
                Text("Save to watch")
            }
        }
        .buttonStyle(.bordered)
    }
    
    private var moveToWatchlistButton: some View {
        Button(action: {
            storage.moveToWatchlist(media)
            updateMediaState()
        }) {
            HStack {
                Image(systemName: "tv")
                Text("Move to watchlist")
            }
            
        }
        .buttonStyle(.bordered)
    }
    
    private var markAsWatchedButton: some View {
        Button(action: {
            storage.markAsWatched(media)
            updateMediaState()
        }) {
            HStack {
                Image(systemName: "checkmark")
                Text("Mark as watched")
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
            }
            
        }
        .buttonStyle(.bordered)
    }

    
    
    func loadWatchProviders() {
        let urlStr = "https://api.themoviedb.org/3/\(media.media_type.rawValue)/\(media.id)/watch/providers?api_key=\(Constants.apiKey)"
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url);
            URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let watchProviderReponse = try JSONDecoder().decode(WatchProviderResponse.self, from: data)
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
        MediaView(media: Media(poster_path: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdrop_path: nil, id: 238, media_type: .movie, title: "The Godfather", name: nil, overview: "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?", release_date: "1972-03-14", first_air_date: nil))
        MediaView(media: Media(poster_path: "/tGmCxGkVMOqig2TrbXAsE9dOVvX.jpg",backdrop_path: nil, id: 238, media_type: .tv, title: nil, name: "Wonder years", overview: "lorem ipsum", release_date: nil, first_air_date: "1975-05-05"))
        MediaView(media: Media(poster_path: "/vDGr1YdrlfbU9wxTOdpf3zChmv9.jpg",backdrop_path: nil, id: 238, media_type: .movie, title: "The Godfather", name: nil, overview: "lorem ipsum", release_date: "1972-03-14", first_air_date: nil))
    }
}
