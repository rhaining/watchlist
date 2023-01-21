//
//  ContentView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            NavigationStack {
                MediaListView(mediaState: .watchlist)
            }
            .tabItem {
                Image(systemName: "tv")
                Text("Watchlist")
            }
            .tag(0)
            
            NavigationStack {
                MediaListView(mediaState: .watched)
            }
            .tabItem {
                Image(systemName: "checkmark")
                Text("Watched")
            }
            .tag(1)
            
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Find")
            }
            .tag(2)
            
            NavigationStack {
                AboutView()
            }
            .tabItem{
                Image(systemName: "info.circle")
                Text("About")
            }
            .tag(3)
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
