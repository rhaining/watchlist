//
//  ContentView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var storage = Storage.shared
    
    var body: some View {
        TabView {
            NavigationView {
                MediaListView(mediaState: .watchlist)
            }
            .tabItem {
                Image(systemName: "tv")
                Text("Watchlist")
            }
            
            NavigationView {
                MediaListView(mediaState: .watched)
            }
            .tabItem {
                Image(systemName: "checkmark")
                Text("Watched")
            }
            
            NavigationView {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Find")
            }
            
            NavigationView {
                AboutView()
            }
            .tabItem{
                Image(systemName: "info.circle")
                Text("About")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
