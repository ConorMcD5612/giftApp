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
                        // TODO: Move to group creation screen
                    }
                }.font(.largeTitle)
                .padding([.leading, .trailing])

                SearchField(searchEntry: $searchEntry)
                .padding([.leading, .trailing])
                
                ScrollView(showsIndicators: false) {
                    if (settings.groups.count > 0) {
                        VStack {
//                            ForEach($settings.recipients, id: \.self.id)
//                            }
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
                }
            }
        }
    }
}

#Preview {
    GroupsMainView().environmentObject(GroupsViewModel()).environmentObject(AppController())
}
