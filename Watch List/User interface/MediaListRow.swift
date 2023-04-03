//
//  MediaListRow.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 1/21/23.
//

import SwiftUI

struct MediaListRow: View {
    let media: Media
    
    var body: some View {
        HStack(alignment: .top) {
            if let imageUrl = media.thumbnailUrl {
                RemoteImageView(imageURL: imageUrl)
                    .frame(width: 100, height: 150)
            } else {
                Color.gray.opacity(0.05)
                    .frame(width: 100, height: 150)
            }
           

            VStack(alignment: .leading, spacing: 4) {
                Text(media.title ?? media.name ?? "")
                    .font(.subheader)
                    .multilineTextAlignment(.leading)
                
                if let year = media.year {
                    Text("(\(year))")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
    }
}

struct MediaListRow_Previews: PreviewProvider {
    static var previews: some View {
        MediaListRow(media: .previewGodfather)
    }
}
