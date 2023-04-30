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
    private let whatsNextHelper = WhatsNextHelper()
    
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

    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                if let overview = media.overview {
                    Text(overview)
                        .font(.primary)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5)
                } else {
                    Spacer()
                }
                if let posterUrl = media.posterUrl ?? media.backdropUrl {
                    Button(action: toggleOverlay) {
                        AsyncImage(url: posterUrl){ image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        } placeholder: {
                            Color.purple.opacity(0.01)
                        }
                    }
                }
            }
            .padding()
            
            VStack(spacing: 10) {
                if let whatsNext = storage.getNextEpisode(tvShow: media) {
                    VStack(spacing: 4) {
                        Text("What's next: ")
                            .font(.subheader)
                            .fontWeight(.semibold)
                        +
                        Text("\(.episodeDescriptor(season: whatsNext.seasonNumber, episode: whatsNext.episodeNumber)) – “\(whatsNext.name ?? "-")”")
                            .font(.primary)

                        Button("Mark episode as watched") {
                            whatsNextHelper.markAsWatched(media: media)
                        }
                            .font(.little)
                            .buttonStyle(.borderedProminent)
                    }
                }
                if let watchedAt = media.watchedAt, mediaState == .watched {
                    Text("Watched on: " + dateFormatter.string(from: watchedAt))
                        .font(.primary)
                }
            }
            .foregroundColor(.white)
            .shadow(color: .black, radius: 5)
            .padding()
            
            VStack(spacing: 10) {
                if let details = mediaDetails ?? media.details {
                    switch details {
                        case .movie(let details):
                            MovieProgressView(movie: media, details: details)
                            
                        case .tv(let details):
                            TVSeasonsView(media: media, tvDetails: details)
                    }
                }
            }
            .padding()

            if let mediaState = mediaState {
                Group {
                    Text("Currently saved to ")
                    + Text("\(Image(systemName: mediaState.imageName)) \(mediaState.title)")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5)
                .padding()
            }
            HStack {
                addToWatchlistButton
                markAsWatchedButton
            }
            
            removeMediaButton
                .padding(.bottom)
            
            MediaStreamingView(media: media)
        }
        .navigationTitle(media.displayTitle!)
        .navigationBarItems(
            trailing:
                HStack {
                    if let year = media.year {
                        Text(year)
                            .font(.little)
                            .foregroundColor(.white)
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
                    Color.black.opacity(0.3)
                        .scaledToFill()
                }
            } else {
                Color.black.opacity(0.6)
                    .scaledToFill()
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
        .background(Color.white.opacity(0.9).cornerRadius(10))
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
        .background(Color.white.opacity(0.9).cornerRadius(10))

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
                Text("Remove from Watchlist")
                    .font(.system(size: 12))
            }
            .padding(5)
            .foregroundColor(mediaState == nil ? .gray : .white)
        }
        .disabled(mediaState == nil)
        .buttonStyle(.bordered)
        .background(Color.white.opacity(0.5).cornerRadius(10))
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
