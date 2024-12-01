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
    
    @State var selection: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                PersonalMainView().environmentObject(personalViewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("Personal Ideas")
                }.tag(0)
                
                // If not signed in, trying to go to the groups view leads to the sign in page
                if signedIn {
                    GroupsMainView()
                        .environmentObject(appController)
                        .environmentObject(groupsViewModel)
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Groups")
                    }.tag(1)
                } else {
                    AuthView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Groups")
                    }.tag(1)
                }
                
                CalendarMainView().environmentObject(calendarViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }.tag(2)
            }
        }
        .onAppear {
            // _ used to silence warning for unused var from addStateDidChangeListener
            _ = Auth.auth().addStateDidChangeListener {auth, user in
                signedIn = user != nil ? true : false
            }
        }
        .onChange(of: signedIn) {
            groupsViewModel.path.removeAll()
        }
    }
}

#Preview {
    MainView().environmentObject(AppController())
}
