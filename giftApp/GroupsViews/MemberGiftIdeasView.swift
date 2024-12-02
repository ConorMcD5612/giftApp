//
//  MemberGiftIdeasView.swift
//  giftApp
//
//  Created by jmathies on 12/1/24.
//

import SwiftUI

struct MemberGiftIdeasView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    @State var searchEntry: String = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Gift Ideas")
                    Spacer()
                    Button("+") {
                        settings.path.append(.addMemberGiftIdeaView)
                    }
                }.font(.largeTitle)
                HStack {
                    Text("For \(settings.getSelectedUser().name) in \(settings.getSelectedGroup().name)")
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }.padding([.leading, .trailing])
        
            SearchField(searchEntry: $searchEntry)
                .padding([.leading, .trailing])
            
            ScrollView(showsIndicators: false) {
                if (settings.getSelectedGroup().memberGiftIdeas[settings.selectedUser]?.count ?? -1 > 0) {
                    VStack {
                        ForEach(settings.getSelectedGroup().memberGiftIdeas[settings.selectedUser] ?? []) { idea in
                            TextButton(title: idea.name, trailingTitle: idea.creationDate.formatted(date: .abbreviated, time: .omitted), text: idea.description) {
                                settings.selectedGiftIdea = idea.id
                                settings.path.append(.memberGiftIdeaView)
                            }
                        }
                    }
                } else {
                    Text("Nobody has added gift ideas for this member!")
                }
            }.scrollBounceBehavior(.basedOnSize)
            .padding([.top, .bottom])
            Spacer()
        }.toolbar() {
            ToolbarItem(placement: .topBarTrailing) {
                Button("About \(settings.getSelectedUser().name)") {
                    settings.path.append(.profileView)
                }
            }
        }
    }
}
