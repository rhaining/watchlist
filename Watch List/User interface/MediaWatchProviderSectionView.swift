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
            
            ForEach(watchProviders, id: \.providerId) { provider in
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
                    
                    Text(provider.providerName ?? "n/a")
                        .font(.system(size: 18))
                    
                    Spacer()
                }
                .padding(1)
            }
           
        }
        .padding()
        .background(Color.white.opacity(0.7).cornerRadius(4))
        .padding(.horizontal)
    }
}

struct MediaWatchProviderSectionView_Previews: PreviewProvider {
    static var previews: some View {
        MediaWatchProviderSectionView(title: "Available to watch:", watchProviders: [.previewNetflix])
    }
}
