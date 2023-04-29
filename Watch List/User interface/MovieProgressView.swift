//
//  MovieProgressView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 2/20/23.
//

import SwiftUI

struct MovieProgressView: View {
    let movie: Media
    let details: MovieDetails
    @ObservedObject private var storage = Storage.shared
    
    @State private var progress: TimeInterval = 0
    @State private var editProgress = false
    

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading) {
                if let runtime = details.readableRuntime() {
                    
                    Text("Runtime – \(runtime)")
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5)
                    
                    if (editProgress) {
                        
                        Button("Save your progress: \(DateComponentsFormatter.tmdb.movieTime(from: progress) ?? "-")", action: save)
                            .buttonStyle(.borderedProminent)
                        
                        Slider(
                            value: $progress,
                            in: 0...TimeInterval(details.runtime ?? 0),
                            label: {
                                Text("hmm").foregroundColor(.white)
                            },
                            minimumValueLabel: { Text("0:00").foregroundColor(.white) },
                            maximumValueLabel: { Text(details.readableRuntime() ?? "-").foregroundColor(.white) }
                        )
                    } else {
                        if (progress > 0) {
                            Text("Current progress: \(DateComponentsFormatter.tmdb.movieTime(from: progress) ?? "-")")
                                .foregroundColor(.white)
                        }
                        
                        Button("Set Progress") {
                            editProgress = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            progress = TimeInterval( storage.getMovieProgress(movie: movie) ?? 0 )
        }
    }
    
    private func save() {
        Task.init {
            await storage.addToWhatsNext(movie: movie, progress: Int(progress))
        }
        editProgress = false
    }
}

struct MovieProgressView_Previews: PreviewProvider {
    static var previews: some View {
        
        MovieProgressView(movie: .previewGodfather, details: .taco)
            .padding(50)
            .background(Color.black)
    }
}
