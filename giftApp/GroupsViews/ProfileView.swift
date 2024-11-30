//
//  ProfileView.swift
//  giftApp
//
//  Created by user264039 on 11/28/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle().frame(width: 150, height: 150)
                    .foregroundStyle(.teal)
                Text("\(appController.userViewModel?.user?.name.prefix(1).uppercased() ?? "")")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .bold()
            }.padding([.bottom])
            
            HStack {
                Text("Name:")
                Text(appController.userViewModel?.user?.name ?? "Name not found")
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Email:")
                Text(appController.userViewModel?.user?.email ?? "Email not found")
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Birthday:")
                if (appController.userViewModel?.user?.birthday != nil) {
                    Text(formatDate(date: (appController.userViewModel?.user?.birthday)!))
                } else {
                    Text("N/A")
                }
                Spacer()
            }
            
            Divider()
            
            VStack {
                HStack {
                    Text("Wishlist:")
                    if (appController.userViewModel?.user?.wishlist?.count == 0 || appController.userViewModel?.user?.wishlist?.count == nil) {
                        Text("Nothing")
                    }
                    Spacer()
                }
                if (appController.userViewModel?.user?.wishlist?.count != 0) {
                    // TODO: Iterate through and display wishlist
                }
            }
            
            Divider()

            VStack {
                HStack {
                    Text("Interests:")
                    if (appController.userViewModel?.user?.interests?.count == 0 || appController.userViewModel?.user?.interests?.count == nil) {
                        Text("None")
                    }

                    Spacer()
                }
                if (appController.userViewModel?.user?.interests?.count != 0) {
                    // TODO: Iterate through and display interests/hobbies
                }
            }
            
            Spacer()
            
            Button("Sign out", role: .destructive) {
                GSignOut()
            }
        }.font(.system(size: 20))
        .padding()
        .toolbar() {
            ToolbarItem(placement: .principal) {
                Text("Viewing Profile").font(.headline)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "square.and.pencil") {
                    settings.path.append(.editProfileView)
                }
            }
        }
    }
    
    func GSignOut() {
        Task {
            do {
                try appController.GSignOut()
                print("GSignOut successful")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    }


#Preview {
    ProfileView().environmentObject(AppController())
}
