//
//  MediaListRow.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/21/23.
//

import SwiftUI

struct MediaListRow: View {
    let media: Media
    let mediaState: MediaState
    @ObservedObject private var storage = Storage.shared

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    var body: some View {
        HStack(alignment: .top) {
            if let imageUrl = media.thumbnailUrl {
                RemoteImageView(imageURL: imageUrl)
                    .frame(width: 100, height: 150)
            } else {
                Color.gray.opacity(0.05)
                    .frame(width: 100, height: 150)
            }
           

            VStack(alignment: .leading, spacing: 4) {
                Text(media.title ?? media.name ?? "")
                    .font(.subheader)
                    .multilineTextAlignment(.leading)
                
                if let year = media.year {
                    Text("(\(year))")
                        .font(.primary)
                        .foregroundColor(.gray)
                }
                
          
                
                if let whatsNext = storage.getNextEpisode(tvShow: media) {
                    VStack(alignment: .leading,spacing: 4) {
                        Text("What's next: ")
                            .font(.primary)
                            .foregroundColor(.teal)
                        
                        Text("\(.episodeDescriptor(season: whatsNext.seasonNumber, episode: whatsNext.episodeNumber)) – “\(whatsNext.name ?? "-")”")
                            .font(.primary)
                            .foregroundColor(.teal)
                        
                        if let airDate = whatsNext.airDate {
                            let airDateStr = DateFormatter.tmdb.string(from: airDate)
                            let airedVerb = airDate.timeIntervalSinceNow < 0 ? "Aired on" : "Airing on"
                            Text("\(airedVerb) \(airDateStr)")
                                .font(.primary)
                                .foregroundColor(.teal)
                        }
                    }
                    .padding(.vertical)
                }
                if let watchedAt = media.watchedAt, mediaState == .watched {
                    Text("Watched on: " + dateFormatter.string(from: watchedAt))
                        .font(.primary)
                        .foregroundColor(.gray)
                        .padding(.vertical)
                } else if let releaseDate = media.releaseDate,
                          let date = DateFormatter.tmdb.date(from: releaseDate),
                          date.timeIntervalSinceNow > 0 {
                    Text("To be released on: " + dateFormatter.string(from: date))
                        .font(.primary)
                        .foregroundColor(.gray)
                        .padding(.vertical)
                }
            }
            
            Spacer()
        }
    }
}

struct MediaListRow_Previews: PreviewProvider {
    static var previews: some View {
        MediaListRow(media: .previewGodfather, mediaState: .watchlist)
        MediaListRow(media: .previewGodfather, mediaState: .watched)
    }
}
