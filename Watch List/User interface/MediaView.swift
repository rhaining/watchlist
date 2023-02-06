//
//  MediaView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI


struct MediaView: View {
    let media: Media
    @State private var mediaDetails: MediaDetails?
    @ObservedObject var storage = Storage.shared
    @State private var exposeFullOverview = false
    @State private var mediaState: MediaState?
    @State private var enableOverlay: Bool = false
    
    init(media: Media) {
        self.media = media
        self.mediaDetails = media.details
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    func showCompactOverview() -> Bool {
        if let overview = media.overview {
            return !exposeFullOverview && overview.count > 150;
        } else {
            return !exposeFullOverview
        }
    }
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                if let overview = media.overview {
                    Button(showCompactOverview() ? "▹" : "▿", action: { exposeFullOverview = !exposeFullOverview })
                    
                    Text(showCompactOverview() ? overview.prefix(150) + "…" : overview)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5)
                        .onTapGesture { exposeFullOverview = !exposeFullOverview }

                } else {
                    Spacer()
                }
                if let posterUrl = media.posterUrl ?? media.backdropUrl {
                    Button(action: toggleOverlay) {
                        AsyncImage(url: posterUrl){ image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        } placeholder: {
                            Color.purple.opacity(0.01)
                        }
                    }
                }
            }
                .padding()
            
            
            VStack(spacing: 10) {
                if let details = mediaDetails ?? media.details {
                    switch details {
                        case .movie(let details):
                            if let runtime = details.readableRuntime() {
                                Text("Runtime: \(runtime)")
                            }
                            
                        case .tv(let details):
                            TVSeasonsView(media: media, tvDetails: details)
                    }
                }
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
                markAsWatchedButton
                    
            }
            
            removeMediaButton
                .padding(.bottom)
            
            MediaStreamingView(media: media)
        }
        .navigationTitle(media.title ?? media.name ?? "")
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarItems(
            trailing:
                HStack {
                    if let year = media.year {
                        Text(year)
                            .font(.system(size: 13))
                    }
                    ShareLink(item: URL(string: "https://www.themoviedb.org/\(media.mediaType.rawValue)/\(media.id)")!)
                    
                }
        )
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
        .overlay {
            if enableOverlay, let posterUrl = media.originalPosterUrl {
                Button(action: toggleOverlay) {
                    AsyncImage(url: posterUrl){ image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ZStack {
                            Color.purple.opacity(0.5)
                            ProgressView()
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            updateMediaState()
            loadDetails()
        })
    }
    
    private func toggleOverlay() {
        enableOverlay = !enableOverlay
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
            Task.init {
                await storage.move(media: media, to: .watchlist)
                updateMediaState()
            }
        }) {
            HStack {
                Image(systemName: MediaState.watchlist.imageName)
                Text("Save to watch")
                    .font(.system(size: 18))
                    .fontWeight(mediaState == .watchlist ? .regular : .semibold)
            }
            .foregroundColor(mediaState == .watchlist ? .gray : .blue)
            .padding(5)
        }
        .disabled(mediaState == .watchlist)
        .buttonStyle(.bordered)
        .background(Color.white.cornerRadius(10))
    }
    
    
    private var markAsWatchedButton: some View {
        Button(action: {
            Task.init {
                await storage.move(media: media, to: .watched)
                updateMediaState()
            }
        }) {
            HStack {
                Image(systemName: MediaState.watched.imageName)
                Text("Mark watched")
                    .font(.system(size: 18))
                    .fontWeight(mediaState == .watched ? .regular : .semibold)
            }
            .foregroundColor(mediaState == .watched ? .gray : .blue)
            .padding(5)
        }
        .disabled(mediaState == .watched)
        .buttonStyle(.bordered)
        .background(Color.white.cornerRadius(10))

    }
    
    private var removeMediaButton: some View {
        Button(action: {
            Task.init {
                await storage.remove(media, save: true)
                updateMediaState()
            }
        }) {
            HStack {
                Image(systemName: "trash")
                Text("Remove")
                    .font(.system(size: 12))
            }
            .padding(5)
            .foregroundColor(mediaState == nil ? .gray : .blue)
        }
        .disabled(mediaState == nil)
        .buttonStyle(.bordered)
        .background(Color.white.cornerRadius(10))
    }    
    
    private func loadDetails() {
        let urlStr = "https://api.themoviedb.org/3/\(media.mediaType.rawValue)/\(media.id)?api_key=\(Constants.apiKey)"
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url);
            URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    var updatedMedia = media
                    switch media.mediaType {
                        case .movie:
                            let movieDetails = try JSONDecoder.tmdb.decode(MovieDetails.self, from: data)
                            updatedMedia.details = .movie(movieDetails)
                            
                        case .tv:
                            let tvDetails = try JSONDecoder.tmdb.decode(TVDetails.self, from: data)
                            updatedMedia.details = .tv(tvDetails)
                            
                        case .all, .person:
                            break
                    }
                    self.mediaDetails = updatedMedia.details
                    Task.init {
                        await Storage.shared.replace(media: media, with: updatedMedia)
                    }
                } catch {
                    NSLog("loadDetails error \(error)")
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
