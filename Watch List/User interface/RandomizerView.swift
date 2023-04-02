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
                            } placeholder: {
                                Color.purple.opacity(0.01)
                            }
                        }
                        
                        Text(media?.name ?? media?.title ?? "")
                            .font(.system(.title))
                    }
                }
                
                Spacer()
            }
            Spacer()
        }
        .overlay(alignment: .topTrailing) {
            Button(action: randomize) {
                Image(systemName: "wand.and.stars")
                    .padding()
            }
            .padding()
        }
        .overlay(alignment: .bottomTrailing) {
            Button("Cancel") {
                dismiss()
            }
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
