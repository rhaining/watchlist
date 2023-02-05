//
//  ContentView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var presentedMedia: [[Media]] = [[], [], [], []]
    
    var selectionBinding: Binding<Int> { Binding(
        get: {
            self.selectedTab
        },
        set: {
            if $0 == self.selectedTab  && presentedMedia.count > 0 {
                // Pop back to root.
                presentedMedia[$0] = []
            }
            self.selectedTab = $0
        }
    )}
    
    var body: some View {
        TabView(selection: selectionBinding) {
            
            NavigationStack(path: $presentedMedia[1]) {
                MediaListView(mediaState: .watchlist)
            }
            .tabItem {
                Image(systemName: MediaState.watchlist.imageName)
                Text(MediaState.watchlist.title)
            }
            .tag(1)
            
            NavigationStack(path: $presentedMedia[2]) {
                MediaListView(mediaState: .watched)
            }
            .tabItem {
                Image(systemName: MediaState.watched.imageName)
                Text(MediaState.watched.title)
            }
            .tag(2)
            
            NavigationStack(path: $presentedMedia[3]) {
                SearchView()
            }
            .tabItem {
                Image(systemName: "plus")
                Text("Add")
            }
            .tag(3)
            
            NavigationStack {
                AboutView()
            }
            .tabItem{
                Image(systemName: "info.circle")
                Text("About")
            }
            .tag(4)
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
