//
//  MediaWatchProviderSectionView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/21/23.
//

import SwiftUI

struct MediaWatchProviderSectionView: View {
    let title: String
    let watchProviders: [WatchProvider]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.headline)
            
            ForEach(watchProviders, id: \.provider_id) { provider in
                HStack {
                    if let logoUrl = provider.logoUrl {
                        AsyncImage(url: logoUrl){ image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        } placeholder: {
                            Color.purple.opacity(0.01)
                        }
                    } else {
                        Text("✧")
                            .font(.system(size: 30))
                            .frame(width: 50, height: 50)
                            .multilineTextAlignment(.center)
                    }
                    
                    Text(provider.provider_name ?? "n/a")
                        .font(.system(size: 18))
                }
                .padding(1)
            }
           
        }
        .padding()
        
    }
}

struct MediaWatchProviderSectionView_Previews: PreviewProvider {
    static var previews: some View {
        MediaWatchProviderSectionView(title: "Available to watch:", watchProviders: [WatchProvider(logo_path: nil, provider_id: 1, display_priority: 1, provider_name: "Netflix")])
    }
}
