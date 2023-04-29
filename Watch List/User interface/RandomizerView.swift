//
//  RandomizerView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import SwiftUI

struct RandomizerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var media: Media?
    @State private var timer: Timer?
    
    let mediaList: [Media]
    let watchIt: (Media?) -> Void

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button(action: { watchIt(media) }) {
                    VStack {
                        if let media = media,
                           let posterUrl = media.thumbnailUrl {
                            AsyncImage(url: posterUrl){ image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 300)
                                    .cornerRadius(10)
                            } placeholder: {
                                Color.white.opacity(0.1)
                                    .frame(width: 150, height: 300)
                                    .cornerRadius(10)
                            }
                        }
         
        
                        Text(media?.name ?? media?.title ?? "")
                            .font(.system(.title))
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        
                    }
                }
                
                Spacer()
            }
            Spacer()
        }
        .background(AnimatedGradientView())
        .overlay(alignment: .topTrailing) {
            Button(action: randomize) {
                Image(systemName: "wand.and.stars")
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            }
            .padding()
        }
        .overlay(alignment: .bottomTrailing) {
            Button("Cancel") {
                dismiss()
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .padding()
        }
        .onAppear(perform: randomize)
    }

    
    private func randomize() {
        guard timer == nil else { return }
        let start = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            media = mediaList.randomElement()
            if start.timeIntervalSinceNow < -2 {
                timer.invalidate()
                self.timer = nil
            }
        }
        timer?.fire()
    }
}

struct RandomizerView_Previews: PreviewProvider {
    static var previews: some View {
        RandomizerView(mediaList: [.previewGodfather, .previewWonderYears]) { media in }
    }
}
