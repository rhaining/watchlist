//
//  MediaStreamingView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/5/23.
//

import SwiftUI

struct MediaStreamingView: View {
    let media: Media
    @State private var watchProviderRegion: WatchProviderRegion?

    var body: some View {
        VStack(alignment: .leading) {
            if let watchProviderRegion = watchProviderRegion {
                    if let providers = watchProviderRegion.flatrate {
                        MediaWatchProviderSectionView(title: "Available to stream", watchProviders: providers, expandable: false)
                    }
                    if let providers = watchProviderRegion.rent {
                        MediaWatchProviderSectionView(title: "Available to rent", watchProviders: providers, expandable: true)
                    }
                    if let providers = watchProviderRegion.buy {
                        MediaWatchProviderSectionView(title: "Available to buy", watchProviders: providers, expandable: true)
                    }
               
                
                Text("Source: JustWatch")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .shadow(color: .black, radius: 5)
                    .italic()
                    .padding(10)
            } else {
                Text("Not currently available to stream")
                    .italic()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5)
                    .padding()
            }
        }
        .onAppear(perform: loadWatchProviders)
    }
        
    private func loadWatchProviders() {
        let urlStr = "https://api.themoviedb.org/3/\(media.mediaType.rawValue)/\(media.id)/watch/providers?api_key=\(Constants.apiKey)"
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url);
            URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let watchProviderReponse = try JSONDecoder.tmdb.decode(WatchProviderResponse.self, from: data)
                    self.watchProviderRegion = watchProviderReponse.results?[Constants.watchRegion]
                    
                } catch {
                    NSLog("loadWatchProviders error \(error)")
                }
            }.resume()
        }
    }
   
}

struct MediaStreamingView_Previews: PreviewProvider {
    static var previews: some View {
        MediaStreamingView(media: .previewGodfatherLong)
    }
}
