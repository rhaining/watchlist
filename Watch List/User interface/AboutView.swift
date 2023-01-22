//
//  AboutView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/16/23.
//

import SwiftUI

struct AboutView: View {
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
            
            Spacer()
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
