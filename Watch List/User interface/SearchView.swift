//
//  SearchView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI

struct SearchView: View {
    @State private var queryString = ""
    @State private var lastSearchedQueryString = ""
    @State private var media: [Media]?
    private let columns = [GridItem(.flexible()),GridItem(.flexible())]
    @State private var isLoading = false
    @State private var task: URLSessionTask?;
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .padding(50)
            } else if let media = media {
                if media.count > 0 {
                    LazyVGrid(columns: columns, spacing: 10){
                        ForEach(media, id: \.id){ m in
                            NavigationLink(value: m) {
                                VStack {
                                    if let thumbnailUrl = m.thumbnailUrl {
                                        RemoteImageView(imageURL: thumbnailUrl)
                                            .frame(width: 150, height: 225)
                                    } else {
                                        Color.gray.opacity(0.05)
                                            .frame(width: 150, height: 225)
                                    }
                                    Text("\(m.title ?? m.name ?? "") \(m.year != nil ? "(\(m.year!))" : "")")
                                    Spacer()
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
            MediaView(media: m)
        }
        .searchable(text: $queryString, placement: .toolbar)
        .onChange(of: queryString, perform: {searchText in searchContent()})
        .onSubmit(of: .search, searchContent)
        .navigationTitle("Find Movies & TV")
    }
    
    func searchContent() {
        guard queryString.count > 0, let encodedQuery = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            media = nil
            return
        }
        
        guard lastSearchedQueryString != queryString else { return }
        
        lastSearchedQueryString = queryString
        
        if let task = task {
            task.cancel()
        }

        let urlStr = "https://api.themoviedb.org/3/search/multi?api_key=\(Constants.apiKey)&language=en-US&page=1&include_adult=false&query=\(encodedQuery)";
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url);
            isLoading = true
            task = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let mediaReponse = try JSONDecoder.tmdb.decode(MediaResponse.self, from: data)
                    self.media = mediaReponse.results.filter({ m in
                        return (m.mediaType == .movie ||
                                m.mediaType == .tv) && (m.title != nil || m.name != nil)
                    });
                } catch {
                    NSLog("error decoding \(error)")
                }
                isLoading = false
                self.task = nil;
            }
            task?.resume()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView()
        }
    }
}
