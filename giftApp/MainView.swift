//
//  MainView.swift
//  giftApp
//
//  Created by user264039 on 10/5/24.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject var appController: AppController
    @StateObject var personalViewModel: PersonalViewModel = PersonalViewModel()
    @StateObject var groupsViewModel: GroupsViewModel = GroupsViewModel()
    @StateObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    @State var signedIn = (Auth.auth().currentUser != nil)
    
    var body: some View {
        VStack {
            TabView {
                PersonalMainView().environmentObject(personalViewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("Personal Ideas")
                }
                
                // If not signed in, trying to go to the groups view leads to the sign in page
                if signedIn {
                    GroupsMainView()
                        .environmentObject(appController)
                        .environmentObject(groupsViewModel)
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Groups")
                    }
                } else {
                    AuthView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Groups")
                    }
                }
                
                CalendarMainView().environmentObject(calendarViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            }
        }.onAppear {
            Task {
                try await appController.initUserData()
            }
            // _ used to silence warning for unused var from addStateDidChangeListener
            _ = Auth.auth().addStateDidChangeListener {auth, user in
                signedIn = user != nil ? true : false
            }
        }
    }
}

#Preview {
    MainView().environmentObject(AppController())
}
