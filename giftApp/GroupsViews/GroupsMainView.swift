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
        
    var body: some View {
        NavigationStack(path: $settings.path) {
            VStack {
                HStack {
                    Button("", systemImage: "person.crop.circle") {
                        settings.path.append(.profileView)
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
                            ForEach($settings.groups, id: \.self.id) { $group in
                                TextButton(title: group.name)
                            }
                        }
                    } else {
                        Text("You're not a member of any groups yet!")
                            .font(.system(size: 20))
                    }
                }.padding([.top, .bottom])
                .scrollBounceBehavior(.basedOnSize)
                
                Spacer()
            }
            .navigationDestination(for: GroupsViewModel.Views.self) { view in
                switch view {
                case .profileView:
                    ProfileView()
                case .editProfileView:
                    EditProfileView()
                case .createGroupView:
                    CreateGroupView()
                }
            }
        }
        .onAppear {
            Task {
                try await appController.initUserData()
                let user: User? = appController.userViewModel?.user
                if user != nil {
                    try await settings.getGroupData(user: user!)
                }
            }
        }
    }
}

#Preview {
    GroupsMainView().environmentObject(GroupsViewModel()).environmentObject(AppController())
}
