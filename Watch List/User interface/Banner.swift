//
//  Banner.swift
//  Watch List
//
//  Created by Robert Tolar Haining on 4/30/23.
//

import SwiftUI

struct Banner: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(Color.red)
            .foregroundColor(Color.white)
            .font(.little)
            .fontWeight(.bold)
            .rotationEffect(.degrees(35))
            .clipped(antialiased: true)
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Color.white
            .frame(width: 300, height: 300)
            .border(Color.gray, width: 5)
            .overlay(alignment: .topTrailing) {
                Banner(text: "New")
            }
    }
}
