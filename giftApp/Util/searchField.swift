//
//  searchField.swift
//  giftApp
//
//  Created by jmathies on 10/18/24.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchEntry: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.gray)
                .padding([.leading, .top, .bottom], 5)
            Divider()
            TextField("Search", text: $searchEntry)
                .padding([.top, .bottom, .trailing], 5)
                .foregroundStyle(.black)
        }.background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.gray)
                .opacity(0.2)
        ).frame(height: 15)
    }
}

