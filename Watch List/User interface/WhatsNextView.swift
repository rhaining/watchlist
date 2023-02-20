//
//  WhatsNextView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import SwiftUI

struct WhatsNextView: View {
    @ObservedObject private var storage = Storage.shared

    var body: some View {
        VStack(alignment: .leading) {
            Text("What's next")
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(storage.whatsNext.filter({ wn in
                        return storage.watchlist.contains(wn.media)
                    }).sorted(by: { a, b in
                        return a.updatedAt > b.updatedAt
                    }), id: \.self) { whatsNextItem in
                        NavigationLink(value: whatsNextItem.media) {
                            VStack {
                                if let tvEp = whatsNextItem.tvEp {
                                    if let imageUrl = tvEp.stillUrl {
                                        RemoteImageView(imageURL: imageUrl)
                                            .frame(width: 100, height: 100)
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                    }
                                    Text(whatsNextItem.media.name ?? "")
                                        .lineLimit(1)
                                    Text(String.episodeDescriptor(season: tvEp.seasonNumber, episode: tvEp.episodeNumber))
                                        .font(.caption)
                                } else if let movie = whatsNextItem.media, movie.mediaType == .movie {
                                    if let imageUrl = movie.posterUrl {
                                        RemoteImageView(imageURL: imageUrl)
                                            .frame(width: 100, height: 100)
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                    }
                                    Text(whatsNextItem.media.title ?? "")
                                        .lineLimit(1)
                                    if let movieProgress = whatsNextItem.movieProgress {
                                        Text("\(DateComponentsFormatter.tmdb.movieTime(from: movieProgress) ?? "")")
                                            .font(.caption)
                                    }
                                }
                            }
                            .frame(width: 100)
                        }
                    }
                }
            }
        }

    }
}

struct WhatsNextView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNextView()
    }
}
