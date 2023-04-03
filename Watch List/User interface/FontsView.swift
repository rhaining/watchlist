//
//  FontsView.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 4/2/23.
//

import SwiftUI

struct FontsView: View {
    
    var body: some View {
        List {
            ForEach(UIFont.familyNames.sorted(), id: \.self) { fontFamily in
                ForEach(UIFont.fontNames(forFamilyName: fontFamily), id: \.self) { fontName in
                    Text("Watchlist: \(fontName)")
                        .font(Font.custom(fontName, size: 18))
                }
            }
        }
    }
}

struct FontsView_Previews: PreviewProvider {
    static var previews: some View {
        FontsView()
    }
}
