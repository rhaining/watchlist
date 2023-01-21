//
//  RemoteImageView.swift
//  Nugget
//
//  Created by Robert Tolar Haining on 10/15/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import SwiftUI

struct RemoteImageView: View {
    let imageURL: URL
    
    @ObservedObject var cachedImageLoader: CachedImageLoader
    
    init(imageURL: URL) {        
        self.imageURL = imageURL
        cachedImageLoader = CachedImageLoader(imageURL: imageURL)
    }
    
    @ViewBuilder
    var body: some View {
        Image(uiImage: UIImage(data: self.cachedImageLoader.data) ?? UIImage())
            .resizable()
            .clipped()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(contentMode: .fill)
    }

}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(imageURL: URL(string: "https://i.ytimg.com/vi/ErwZQBkyX50/default.jpg")!)
    }
}
