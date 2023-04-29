//
//  TVSeasonsView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/5/23.
//

import SwiftUI

struct TVSeasonsView: View {
    let media: Media
    let tvDetails: TVDetails?
    @State private var expandedSeason: TVSeason?
    @State internal var seasonDetailsMap: [Int: TVSeasonDetails] = [:]
    @State private var selectedEpisode: TVEpisode?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let seasons = tvDetails?.seasons {
                Text(" \(seasons.count) season\(seasons.count == 1 ? "" : "s") of \(media.name ?? media.title ?? "…")")
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(seasons) { s in
                            Button {
                                selectSeason(s)
                            } label: {
                                VStack {
                                    Text((s == expandedSeason ? "👇" : "👉") + " season \(s.seasonNumber ?? 0)")
                                        .font(.little)
                                        .padding(5)
                                        .fontWeight(s == expandedSeason ? .bold : .regular)
                                        .background(s == expandedSeason ? .blue : .clear)
                                        .foregroundColor(.white)
                                    
                                    if let imageUrl = s.thumbnailUrl {
                                        RemoteImageView(imageURL: imageUrl)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 100)
                                    }
                                }
                                .border(Color.blue, width: s == expandedSeason ? 3 : 0)
                            }
                            
                        }
                    }
                }

                if let s = expandedSeason {
                    seasonDetailsSection(seasonNumber: s.seasonNumber)
                }
            }
        }
    }
    
    
    private func select(episode: TVEpisode) {
        selectedEpisode = episode
    }
    
    private func text(for episode: TVEpisode) -> String {
        var text = "";
        if let epNumber = episode.episodeNumber {
            text += "\(epNumber). "
        }
        if let name = episode.name {
            text += name + " "
        }
        if let airDate = episode.airDate {
            let airDateStr = DateFormatter.tmdb.string(from: airDate)
            text += "(\(airDateStr))"
        }
        return text;
    }
    
    private func seasonDetailsSection(seasonNumber: Int?) -> some View {
        guard let seasonNumber = seasonNumber,
              let details = seasonDetailsMap[seasonNumber],
              let episodes = details.episodes else {
            return AnyView(EmptyView())
        }
        return AnyView(
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        self.expandedSeason = nil
                    }
                        .buttonStyle(.plain)
                        .foregroundColor(.blue)
                        .padding()

                    Button("Save \(.episodeDescriptor(season: seasonNumber, episode: selectedEpisode?.seasonNumber == seasonNumber ? selectedEpisode?.episodeNumber : 1)) to What's Next", action: saveSelectedEpisode)
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(selectedEpisode?.seasonNumber == seasonNumber ? Color.white : Color.gray)
                        .disabled(selectedEpisode?.seasonNumber != seasonNumber)
                        .padding()
                    
                    Spacer()
                }
                ForEach(episodes) { ep in
                    Button {
                        select(episode: ep)
                    } label: {
                        HStack {
                            if let imageUrl = ep.stillUrl {
                                RemoteImageView(imageURL: imageUrl)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100)
                            } else {
                                Color.gray.opacity(0.2)
                                    .frame(width: 100, height: 50)
                            }
                            Text(text(for: ep))
                                .foregroundColor(ep == selectedEpisode ? Color.white : Color.gray)
                                .font(.primary)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .background(ep == selectedEpisode ? Color.blue.opacity(0.5) : Color.white.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 0)
                }
            }
                .padding(.bottom, 10)
                .border(Color.gray, width: 2)
                .cornerRadius(5)
        )
    }
    
    private func saveSelectedEpisode() {
        if let selectedEp = selectedEpisode {
            Task.init {
                await Storage.shared.addToWhatsNext(tvShow: media, episode: selectedEp)
            }
            self.expandedSeason = nil
        }
    }
    
    private func selectSeason(_ season: TVSeason) {
        expandedSeason = season
        loadSeason(season)
    }
    
    private func updateSelectedEpisode() {
        guard let expandedSeason = expandedSeason else { return }
        
        selectedEpisode = Storage.shared.getNextEpisode(tvShow: media);
    }
    
    private func loadSeason(_ season: TVSeason) {
        guard let seasonNumber = season.seasonNumber, seasonDetailsMap[seasonNumber] == nil else { return }
        
        TmdbApi.loadSeason(tvShow: media, seasonNumber: seasonNumber) { result in
            switch result {
                case .success(let seasonDetails):
                    seasonDetailsMap[seasonNumber] = seasonDetails
                    updateSelectedEpisode()
                    
                case .failure(_):
                    break
            }
        }
    }
}

struct TVSeasonsView_Previews: PreviewProvider {
    static var previews: some View {
        TVSeasonsView(media: Media.previewWonderYears, tvDetails: .community, seasonDetailsMap: [1: .communityOne, 2: .communityOne])
            .background(Color.black)
    }
}
