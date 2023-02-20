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
    @State private var selectedEpisodeIndex = 0
    
    var body: some View {
        VStack {
            if let seasons = tvDetails?.seasons {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        Text(" \(seasons.count) season\(seasons.count == 1 ? "" : "s")")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        ForEach(seasons) { s in
                            Button {
                                selectSeason(s)
                            } label: {
                                VStack {
                                    Text("season \(s.seasonNumber ?? 0)")
                                        .padding(5)
                                        .fontWeight(s == expandedSeason ? .bold : .regular)
                                        .background(s == expandedSeason ? .blue : .clear)
                                        .foregroundColor(.white)
                                    
                                    if let imageUrl = s.thumbnailUrl {
                                        RemoteImageView(imageURL: imageUrl)
                                            .frame(width: 100, height: 150)
                                            .border(Color.blue, width: s == expandedSeason ? 3 : 0)
                                    }
                                }
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
    
    private func seasonDetailsSection(seasonNumber: Int?) -> some View {
        guard let seasonNumber = seasonNumber,
              let details = seasonDetailsMap[seasonNumber],
              let episodes = details.episodes else {
            return AnyView(EmptyView())
        }
        return AnyView(
            VStack {
                HStack {
                    Button("Cancel") {
                        self.expandedSeason = nil
                    }
                        .buttonStyle(.plain)
                        .foregroundColor(.blue)
                        .padding()

                    Button("Save \(.episodeDescriptor(season: seasonNumber, episode: selectedEpisodeIndex < episodes.count ? episodes[selectedEpisodeIndex].episodeNumber : episodes[0].episodeNumber)) to What's Next", action: saveSelectedEpisode)
                        .buttonStyle(.borderedProminent)
                        .padding()
                }
                Picker("What's next", selection: $selectedEpisodeIndex) {
                    ForEach(Array(episodes.enumerated()), id: \.offset) { epIndex, ep in
                        Text("\(ep.episodeNumber ?? 0). \(ep.name ?? "??")")
                            .tag(epIndex)
                    }
                }
                .pickerStyle(.inline)
                .background(Color.white.opacity(0.9))
            }
        )
    }
    
    private func saveSelectedEpisode() {
        if let expandedSeason = expandedSeason,
           let seasonNumber = expandedSeason.seasonNumber,
           let details = seasonDetailsMap[seasonNumber],
           let episodes = details.episodes {
            let selectedEp = episodes[selectedEpisodeIndex];
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
    
    private func updateSelectedEpisodeIndex() {
        guard let expandedSeason = expandedSeason else { return }
        
        if let tvEp = Storage.shared.getNextEpisode(tvShow: media),
           tvEp.seasonNumber == expandedSeason.seasonNumber,
           let seasonNumber = expandedSeason.seasonNumber,
           let details = seasonDetailsMap[seasonNumber],
           let episodes = details.episodes,
           let theEpIndex = episodes.firstIndex(of: tvEp) {
            selectedEpisodeIndex = theEpIndex
        } else {
            selectedEpisodeIndex = 0
        }
    }
    
    private func loadSeason(_ season: TVSeason) {
        guard let seasonNumber = season.seasonNumber, seasonDetailsMap[seasonNumber] == nil else { return }
        
        TmdbApi.loadSeason(tvShow: media, seasonNumber: seasonNumber) { result in
            switch result {
                case .success(let seasonDetails):
                    seasonDetailsMap[seasonNumber] = seasonDetails
                    updateSelectedEpisodeIndex()
                    
                case .failure(_):
                    break
            }
        }
    }
}

struct TVSeasonsView_Previews: PreviewProvider {
    static var previews: some View {
        TVSeasonsView(media: Media.previewGodfatherLong, tvDetails: .community, seasonDetailsMap: [1: .communityOne])
    }
}
