//
//  SearchView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI

struct SearchView: View {
    let person: Media?
    
    @State private var queryString = ""
    @State private var results: [Media]?
    private let columns = [GridItem(.flexible()),GridItem(.flexible())]
    @State private var isLoading = false
    @State private var task: URLSessionTask?
    
    init(person: Media? = nil) {
        self.person = person
    }
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .padding(50)
            } else if let results = results {
                if results.count > 0 {
                    LazyVGrid(columns: columns, spacing: 10){
                        ForEach(results, id: \.id){ media in
                            NavigationLink(value: media) {
                                VStack {
                                    if let thumbnailUrl = media.thumbnailUrl {
                                        RemoteImageView(imageURL: thumbnailUrl)
                                            .frame(width: 150, height: 225)
                                    } else {
                                        Color.gray.opacity(0.05)
                                            .frame(width: 150, height: 225)
                                    }
                                    Text("\(media.title ?? media.name ?? "") \(media.year != nil ? "(\(media.year!))" : "")")
                                    Spacer()
                                }
                                .contextMenu {
                                    Button(action: {
                                        Task.init {
                                            await Storage.shared.move(media: media, to: .watchlist)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: MediaState.watchlist.imageName)
                                            Text("Add to watchlist")
                                                .font(.system(size: 18))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                } else if queryString.count > 0 {
                    Text("No results found for '\(queryString)'.")
                        .padding()
                }
            }
        }
        .navigationDestination(for: Media.self) { m in
            switch m.mediaType {
                case .tv, .movie, .all:
                    MediaView(media: m)
                    
                case .person:
                    SearchView(person: m)
            }
            
        }
        .searchable(text: $queryString, placement: .toolbar)
        .onChange(of: queryString, perform: {searchText in searchContent()})
        .onSubmit(of: .search, searchContent)
        .navigationTitle(navTitle())
        .onAppear() {
            if person != nil {
                searchContent()
            }
        }
    }
    
    private func navTitle() -> String {
        if let person = person {
            return person.name ?? "Credits"
        } else {
            return "Find Movies & TV"
        }
    }
    
    private func searchUrl() -> URL? {
        let urlStr: String
        
        if let person = person {
            urlStr = "https://api.themoviedb.org/3/person/\(person.id)/combined_credits?api_key=\(Constants.apiKey)&language=en-US";
        } else if queryString.count > 0, let encodedQuery = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlStr = "https://api.themoviedb.org/3/search/multi?api_key=\(Constants.apiKey)&language=en-US&page=1&include_adult=false&query=\(encodedQuery)";
        } else {
            return nil;
        }
        
        return URL(string: urlStr)
    }
    
    func searchContent() {
        guard let searchUrl = searchUrl() else {
            results = nil
            return
        }
        
        let request = URLRequest(url: searchUrl);
        isLoading = true
        task = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let mediaResults: [Media]
                if person == nil {
                    let mediaReponse = try JSONDecoder.tmdb.decode(MediaResponse.self, from: data)
                    mediaResults = mediaReponse.results
                } else {
                    let mediaReponse = try JSONDecoder.tmdb.decode(PersonCreditsResponse.self, from: data)
                    mediaResults = mediaReponse.cast + mediaReponse.crew
                }
                self.results = mediaResults.filter({ m in
                    return (m.mediaType == .movie || m.mediaType == .tv || m.mediaType == .person) && (m.title != nil || m.name != nil)
                });
            } catch {
                NSLog("error decoding \(error)")
            }
            isLoading = false
            self.task = nil;
        }
        task?.resume()
//        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView(person: nil)
        }
    }
}
