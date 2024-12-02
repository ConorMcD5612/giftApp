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
    @Environment(\.dismiss) private var dismiss
    @State var signoutConfirmation: Bool = false
        
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func wishlistString(wishlist: [String]) -> String {
        var string = ""
        
        for item in wishlist {
            string += item
            if (wishlist.count > 1 && wishlist.last != item) {
                string += ", "
            }
        }
        
        return string
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ZStack {
                        Circle().frame(width: 150, height: 150)
                            .foregroundStyle(.teal)
                        Text("\(settings.getSelectedUser().name.prefix(1).uppercased())")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .bold()
                    }.padding([.bottom])
                    
                    HStack {
                        Text("Name:")
                        Text(settings.getSelectedUser().name)
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Email:")
                        Text(settings.getSelectedUser().email)
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Birthday:")
                        if (settings.getSelectedUser().birthday != nil) {
                            Text("\(settings.getSelectedUser().birthmonth ?? "January") \(settings.getSelectedUser().birthday ?? 1)")
                        } else {
                            Text("N/A")
                        }
                        Spacer()
                    }
                    
                    Divider()
                    
                    VStack {
                        HStack {
                            Text("Wishlist:")
                            Spacer()
                        }
                        HStack {
                            if (settings.getSelectedUser().wishlist.count == 0) {
                                Text("Nothing")
                            } else {
                                Text(wishlistString(wishlist: settings.getSelectedUser().wishlist))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                    }
                    
                    Divider()
                    
                    VStack {
                        HStack {
                            Text("About:")
                            Spacer()
                        }
                        HStack {
                            if (settings.getSelectedUser().about.count == 0) {
                                Text("Blank")
                            } else {
                                Text(settings.getSelectedUser().about)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }.scrollBounceBehavior(.basedOnSize)
            if (settings.selectedUser == appController.userViewModel?.user?.id) {
                Button("Sign out", role: .destructive) {
                    signoutConfirmation = true
                }
                .confirmationDialog("Are you sure you want to sign out?", isPresented: $signoutConfirmation, titleVisibility: .visible) {
                    Button("Sign out", role: .destructive) {
                        signoutConfirmation = false
                        Task {
                            do {
                                try appController.GSignOut()
                                print("Signout successful")
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        signoutConfirmation = false
                    }
                }
            }
        }
        .font(.system(size: 20))
        .padding()
        .toolbar() {
            ToolbarItem(placement: .principal) {
                if settings.selectedUser == appController.userViewModel?.user?.id {
                    Text("Viewing Your Profile").font(.headline)
                } else {
                    Text("Viewing Member Profile").font(.headline)
                }
            }
            
            if settings.selectedUser == appController.userViewModel?.user?.id {
                ToolbarItem(placement: .confirmationAction) {
                    Button("", systemImage: "square.and.pencil") {
                        settings.path.append(.editProfileView)
                    }
                }
            }
        }
    }
}
