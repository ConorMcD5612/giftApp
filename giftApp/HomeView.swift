//
//  HomeView.swift
//  giftApp
//
//  Created by user264039 on 10/5/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView() {
            PeopleView()
                .tabItem() {
                    Image(systemName: "person")
                }
            PeopleView()
                .tabItem() {
                    Image(systemName: "person.2")
                }
            PeopleView()
                .tabItem() {
                    Image(systemName: "calendar")
                }
        }
    }
}

#Preview {
    HomeView()
}
