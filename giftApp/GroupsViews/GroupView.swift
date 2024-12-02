//
//  GroupView.swift
//  giftApp
//
//  Created by jmathies on 12/1/24.
//

import SwiftUI

struct GroupView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    @Binding var group: Group

    @State var searchEntry: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(group.name)
                Spacer()
            }.font(.largeTitle)
            .padding([.leading, .trailing])

            SearchField(searchEntry: $searchEntry)
            .padding([.leading, .trailing])
            
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(Array(group.memberGiftIdeas.keys).sorted(), id: \.self) { memberID in
                        if memberID != appController.userViewModel?.user?.id && group.members.contains(memberID) {
                            IconButton(text: settings.visibleUsers[memberID]?.name ?? "") {
                                settings.selectedUser = settings.visibleUsers[memberID]
                                settings.path.append(.memberGiftIdeasView)
                            }
                        }
                    }
                }
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
