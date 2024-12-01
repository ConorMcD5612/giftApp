//
//  GroupView.swift
//  giftApp
//
//  Created by jmathies on 12/1/24.
//

import SwiftUI

struct GroupView: View {
    @EnvironmentObject var settings: GroupsViewModel
    @Binding var group: Group

    @State var searchEntry: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(group.name)
                Spacer()
                Button("+") {
                    // TODO: Create Add Gift Idea Menu
                }
            }.font(.largeTitle)
            .padding([.leading, .trailing])

            SearchField(searchEntry: $searchEntry)
            .padding([.leading, .trailing])
            
            ScrollView(showsIndicators: false) {
//                VStack {
//                    ForEach(Array(settings.groups.values), id: \.self.id) { group in
//                        TextButton(title: group.name, text: "Members: You")
//                    }
//                }
            }.padding([.top, .bottom])
            .scrollBounceBehavior(.basedOnSize)
            
            Spacer()
        }.toolbar() {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit Group") {
                    settings.path.append(.editGroupView)
                }
            }
        }
    }
}
