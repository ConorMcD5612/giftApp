//
//  GroupsView.swift
//  giftApp
//
//  Created by jmathies on 10/16/24.
//

import SwiftUI

struct GroupsMainView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    @State var searchEntry: String = ""
    @State var loadingGroups: Bool = false
        
    var body: some View {
        NavigationStack(path: $settings.path) {
            VStack {
                HStack {
                    Button("", systemImage: "person.crop.circle") {
                        let user = appController.userViewModel?.user
                        if user != nil {
                            settings.selectedUser = user!
                            settings.path.append(.profileView)
                        }
                    }
                    Text("Your Groups")
                    Spacer()
                    Button("+") {
                        settings.path.append(.createGroupView)
                    }
                }.font(.largeTitle)
                .padding([.leading, .trailing])

                SearchField(searchEntry: $searchEntry)
                .padding([.leading, .trailing])
                
                ScrollView(showsIndicators: false) {
                    if (settings.groups.count > 0) {
                        VStack {
                            ForEach(Array(settings.groups.values), id: \.self.id) { group in
                                TextButton(title: group.name, text: "Members: \(settings.getMembers(from: group, currentUserID: appController.userViewModel?.user?.id ?? ""))") {
                                    settings.selectedGroup = group
                                    settings.path.append(.groupView)
                                }
                            }
                        }
                    } else {
                        if loadingGroups {
                            Text("Loading your groups...")
                                .font(.system(size: 20))
                        } else {
                            Text("You're not a member of any groups!")
                                .font(.system(size: 20))
                        }
                    }
                }.padding([.top, .bottom])
                .scrollBounceBehavior(.basedOnSize)
                
                Spacer()
            }
            .navigationDestination(for: GroupsViewModel.Views.self) { view in
                switch view {
                case .profileView:
                    ProfileView(user: $settings.selectedUser)
                case .editProfileView:
                    EditProfileView()
                case .createGroupView:
                    CreateGroupView()
                case .groupView:
                    GroupView(group: $settings.selectedGroup)
                case .editGroupView:
                    EditGroupView(group: $settings.selectedGroup)
                case .memberGiftIdeasView:
                    MemberGiftIdeasView(user: $settings.selectedUser, group: $settings.selectedGroup)
                case .addMemberGiftIdeaView:
                    AddGroupGiftIdeaView(recipient: $settings.selectedUser, group: $settings.selectedGroup)
                }
            }
        }
        .onAppear {
            Task {
                if (settings.groups.count == 0) {
                    loadingGroups = true
                }
                try await appController.initUserData()
                let user: User? = appController.userViewModel?.user
                if user != nil {
                    try await settings.getGroupData(user: user!)
                }
                loadingGroups = false
            }
        }
    }
}

#Preview {
    GroupsMainView().environmentObject(GroupsViewModel()).environmentObject(AppController())
}
