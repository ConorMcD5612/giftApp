//
//  MainView.swift
//  giftApp
//
//  Created by user264039 on 10/5/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            PeopleView()
                .tabItem {
                    Image(systemName: "person")
                    Text("People")
                }
            GroupsMainView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Groups")
                }
            CalendarMainView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            ProfileMainView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    MainView()
}
