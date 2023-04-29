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
    let expandable: Bool
    @State internal var showData: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                if expandable {
                    Button {
                        showData = !showData
                    } label: {
                        Image(systemName: "arrowtriangle.\(showData ? "down" : "right")")
                    }

                }
                Text(title + (showData ? ":" : ""))
                    .font(.headline)
                Spacer()
            }
            if showData {
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
                                    .frame(width: 50)
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
        }
        .padding()
        .background(Color.white.opacity(0.7).cornerRadius(4))
        .padding(.horizontal)
        .onAppear() {
            showData = !expandable
        }
    }
}

struct MediaWatchProviderSectionView_Previews: PreviewProvider {
    static var previews: some View {
        MediaWatchProviderSectionView(title: "Available to watch:", watchProviders: [.previewNetflix], expandable: true, showData: false)
        MediaWatchProviderSectionView(title: "Available to stream:", watchProviders: [.previewNetflix], expandable: false, showData: true)
    }
}
