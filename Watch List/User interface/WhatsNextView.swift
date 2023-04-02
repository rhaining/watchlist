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
            Text("Okay, what's next?")
                .fontWeight(.black)
            
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
                                    whatsNextCell(imageUrl: tvEp.stillUrl ?? whatsNextItem.media.thumbnailUrl,
                                                  title: whatsNextItem.media.name,
                                                  caption: .episodeDescriptor(season: tvEp.seasonNumber, episode: tvEp.episodeNumber)
                                    )
                                } else if let movie = whatsNextItem.media, movie.mediaType == .movie {
                                    whatsNextCell(imageUrl: movie.posterUrl,
                                                  title: whatsNextItem.media.title,
                                                  caption: movieProgressCaption(for: whatsNextItem)
                                    )
                                }
                            }
                            .frame(width: 90)
                            .padding(.bottom)
                        }
                    }
                }
            }
        }
    }
    
    func movieProgressCaption(for whatsNextItem: WhatsNext) -> String? {
        if let progress = DateComponentsFormatter.tmdb.movieTime(from: whatsNextItem.movieProgress) {
            return "⏱️ \(progress)"
        } else {
            return nil
        }
    }
    
    func whatsNextCell(imageUrl: URL?, title: String?, caption: String?) -> some View {
        VStack {
            if let imageUrl = imageUrl {
                RemoteImageView(imageURL: imageUrl)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
            }
            Text(title ?? "")
                .lineLimit(1)
            Text(caption ?? "")
                .font(.caption)
        }
    }
}

struct WhatsNextView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNextView()
    }
}
