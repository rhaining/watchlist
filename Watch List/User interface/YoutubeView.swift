//
//  YoutubeView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 8/15/23.
//

import SwiftUI
import YouTubeiOSPlayerHelper

struct YoutubeView: UIViewRepresentable {
    typealias UIViewType = YTPlayerView
    
    @Binding var videoKey: String?
    
    func makeUIView(context: Context) -> YTPlayerView {
        let view = YTPlayerView()
        NSLog("makeUIView")
        
        // Do some configurations here if needed.
        return view
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
        
        NSLog("update UI View \(context)")
        if let videoKey = videoKey {
            uiView.load(withVideoId: videoKey)
        }
    }
}

struct YoutubeView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeView(videoKey: .constant("abc"))
    }
}
