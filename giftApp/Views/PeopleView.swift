//
//  PeopleView.swift
//  giftApp
//
//  Created by jmathies on 10/16/24.
//

import SwiftUI

struct PeopleView: View {
    @State var searchEntry: String = ""
    
    var body: some View {
        VStack(spacing: 50) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $searchEntry)
                    .border(.primary)
                Circle()
                    .fill(.gray)
                    .frame(width: 80)
            }.textFieldStyle(.roundedBorder)
            Text(searchEntry)
            Spacer()
        }.padding()
    }
}

#Preview {
    PeopleView()
}
