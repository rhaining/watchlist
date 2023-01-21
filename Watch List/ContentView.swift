//
//  ContentView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var presentedMedia: [Media] = []
    
    var selectionBinding: Binding<Int> { Binding(
        get: {
            self.selectedTab
        },
        set: {
            if $0 == self.selectedTab  && presentedMedia.count > 0 {
                // Pop back to root.
                presentedMedia = []
            }
            self.selectedTab = $0
        }
    )}
    
    var body: some View {
        TabView(selection: selectionBinding) {
            NavigationStack(path: $presentedMedia) {
                MediaListView(mediaState: .watchlist)
            }
            .tabItem {
                Image(systemName: "tv")
                Text("Watchlist")
            }
            .tag(0)
            
            NavigationStack(path: $presentedMedia) {
                MediaListView(mediaState: .watched)
            }
            .tabItem {
                Image(systemName: "checkmark")
                Text("Watched")
            }
            .tag(1)
            
            NavigationStack(path: $presentedMedia) {
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
