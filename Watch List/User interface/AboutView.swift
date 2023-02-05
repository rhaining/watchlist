//
//  AboutView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI

struct AboutView: View {
    @State private var displayPrompt: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("TV Plus Plus is brought to you by Robert Tolar Haining.")
                .padding()
            
            Text("Check out more projects at:")
                .padding(.horizontal)
            
            HStack {
                Spacer()
                
                Link("kindofawesome.com", destination: URL(string: "https://kindofawesome.com/")!)
                    .buttonStyle(.bordered)

                Spacer()
            }
            
            
            Text("Search provided by The Movie Database, and streaming data by Just Watch.")
                .padding(.horizontal)
                .padding(.top)
            
            HStack {
                Spacer()
                
                Link(destination: URL(string: "https://www.themoviedb.org/")!) {
                    Image("tmdbLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .padding()
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            HStack(alignment: .center) {
                Spacer()
                
                Link(destination: URL(string: "https://www.justwatch.com//")!) {
                    Image("justwatchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125)
                        .padding()
                }
                    .buttonStyle(.bordered)
                
                Spacer()
            }
            
            Text("Nota Bene: Media lists are stored locally on your phone. Backups are currently not available.")
                .padding()
            
            Button("Restore to factory settings", action: promptToRestore)
                .padding()
            
            Spacer()
        }
        .navigationTitle("About")
        .alert("Are you sure you want to clear the watchlist and the watched list?", isPresented: $displayPrompt) {
            Button(role: .destructive) {
                Task.init {
                    await Storage.shared.restoreToFactorySettings()
                }
            } label: {
                Text("Clear my data")
            }
            Button("Cancel", role: .cancel, action: {})
        }
    }
                   
    private func promptToRestore() {
        displayPrompt = true
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
