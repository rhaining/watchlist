//
//  VideoView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 8/15/23.
//

import SwiftUI

struct VideoView: View {
    let media: Media
    @State private var videos: [Video]?
    @State private var presentYoutube = false
    @State private var videoKey: String?
    
    private let maxInitialVideos = 3
    @State private var displayedVideos: [Video]?
    @State private var hasMoreVideos: Bool = false
    
    var body: some View {
        if let displayedVideos = displayedVideos {
            if displayedVideos.count > 0  {
                VStack (alignment: .leading, spacing: 0) {
                    Text("Videos")
                        .font(.subheader)
                        .padding(.horizontal)
                        .padding(.top)
                    ForEach(displayedVideos, id: \.id) { video in
                        Button {
                            videoKey = video.key
                            presentYoutube = true
                        } label: {
                            HStack (alignment: .center, spacing: 0) {
                                Image(systemName: "play.circle")
                                    .frame(width: 60, height: 60)
                                
                                Text(video.name ?? video.type ?? "video")
                                    .font(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                    }
                    if hasMoreVideos {
                        Button("Display all \(videos!.count) videos…") {
                            self.hasMoreVideos = false
                            self.displayedVideos = videos
                        }
                        .padding()
                    }
                }
                .background(Color.white.opacity(0.8))
                .padding(.horizontal)
                .sheet(isPresented: $presentYoutube) {
                    YoutubeView(videoKey: $videoKey)
                }
            }
        } else {
            Text("Loading videos…")
                .onAppear(perform: loadVideos)
                .foregroundColor(.white)
        }
    }
    
    private func loadVideos() {
        let urlStr = "https://api.themoviedb.org/3/\(media.mediaType.rawValue)/\(media.id)/videos?api_key=\(Constants.apiKey)"
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url);
            URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let videosReponse = try JSONDecoder.tmdbWithFullDate.decode(VideosResponse.self, from: data)
                    videos = videosReponse.results
                    if let videos = videos,
                        videos.count > maxInitialVideos {
                        displayedVideos = Array(videos[0..<maxInitialVideos])
                        hasMoreVideos = true
                    } else {
                        displayedVideos = videos
                    }
                    
                } catch {
                    NSLog("load videos error \(error)")
                }
            }.resume()
        }
    }
    
    
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(media: .previewGodfather)
    }
}
