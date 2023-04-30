//
//  WhatsNextView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import SwiftUI

struct WhatsNextView: View {
    @ObservedObject private var storage = Storage.shared
    private let whatsNextHelper = WhatsNextHelper()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Okay? Okay. What's next?")
                .font(.header)
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(storage.whatsNext.filter({ wn in
                        if storage.watchlist.contains(wn.media) {
                            if let airDate = wn.tvEp?.airDate {
                                let twelveHours = TimeInterval(12 * 60 * 60)
                                return airDate.timeIntervalSinceNow < twelveHours
                            } else {
                                return true
                            }
                        } else {
                            return false
                        }
                    }).sorted(by: { a, b in
                        return a.updatedAt > b.updatedAt
                    }), id: \.self) { whatsNextItem in
                        NavigationLink(value: whatsNextItem.media) {
                            VStack {
                                if let tvEp = whatsNextItem.tvEp {
                                    whatsNextCell(imageUrl: whatsNextItem.media.thumbnailUrl,
                                                  title: whatsNextItem.media.name,
                                                  caption: .episodeDescriptor(season: tvEp.seasonNumber, episode: tvEp.episodeNumber),
                                                  media: whatsNextItem.media
                                    )
                                } else if whatsNextItem.media.mediaType == .movie {
                                    whatsNextCell(imageUrl: whatsNextItem.media.posterUrl,
                                                  title: whatsNextItem.media.title,
                                                  caption: movieProgressCaption(for: whatsNextItem),
                                                  media: whatsNextItem.media
                                    )
                                }
                            }
                            .frame(width: 130)
                            .padding(.bottom, 5)
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
    
    func whatsNextCell(imageUrl: URL?, title: String?, caption: String?, media: Media) -> some View {
        VStack {
            if let imageUrl = imageUrl {
                RemoteImageView(imageURL: imageUrl)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130)
            }
            Text(title ?? "")
                .font(.little)
                .lineLimit(1)
            Text(caption ?? "")
                .font(.little)
        }
//        This wasn't quite acting right
//        .contextMenu {
//            Button(action: {
//                Task.init {
//                    whatsNextHelper.markAsWatched(media: media)
//                }
//            }) {
//                HStack {
//                    Image(systemName: MediaState.watched.imageName)
//                    Text("Mark as watched")
//                        .font(.system(size: 18))
//                }
//            }
//        }
    }
}

struct WhatsNextView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNextView()
    }
}
