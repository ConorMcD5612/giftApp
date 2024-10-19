//
//  PeopleView.swift
//  giftApp
//
//  Created by jmathies on 10/16/24.
//

import SwiftUI

struct PeopleView: View {
    static var FIELD_CHAR_LIMIT: Int = 32
    
    @State var searchEntry: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("People")
                Spacer()
                Button("+", action: {})
            }.font(.largeTitle)
                .padding([.leading, .trailing])
            SearchField(searchEntry: $searchEntry)
                .padding([.leading, .trailing])
            ScrollView(showsIndicators: false) {
                VStack {
                    IconButton(text: "Dave")
                    IconButton(text: "John")
                    IconButton(text: "Sarah")
                    IconButton(text: "Jason")
                    IconButton(text: "Michael")
                    IconButton(text: "Jordan")
                    IconButton(text: "Keller")
                }
            }.scrollBounceBehavior(.basedOnSize)
            .padding([.top, .bottom])
        }
    }
}

#Preview {
    PeopleView()
}
