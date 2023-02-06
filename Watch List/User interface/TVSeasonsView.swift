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
    @State private var expandedSeasons = false
    
    var body: some View {
        VStack {
            if let seasons = tvDetails?.seasons {
                
                    Button(action: { expandedSeasons = !expandedSeasons}) {
                        HStack {
                            Text(expandedSeasons ? "▿" : "▹")
                                .foregroundColor(.blue)
                            + Text(" \(seasons.count) season\(seasons.count == 1 ? "" : "s")")
                        }
                    }
                    
               

                if expandedSeasons {
                    ForEach(seasons) { s in
                        Text("\(s.seasonNumber ?? 0). \(s.name ?? "?")")
                    }
                }
            }
        }
    }
}

struct TVSeasonsView_Previews: PreviewProvider {
    static var previews: some View {
        TVSeasonsView(media: Media.previewGodfatherLong, tvDetails: .community)
    }
}
