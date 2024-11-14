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
    @StateObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    @State var signedIn = (Auth.auth().currentUser != nil)
    
    var body: some View {
        VStack {
            
            
            if signedIn {
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
                        .environmentObject(calendarViewModel)
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
            } else {
                AuthView()
            }
        }.onAppear {
            Task {
                try await appController.initUserData()
            }
            
            Auth.auth().addStateDidChangeListener {auth, user in
                signedIn = user != nil ? true : false
            }
        }
    }
}

#Preview {
    MainView()
}
