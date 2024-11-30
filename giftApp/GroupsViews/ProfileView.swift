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
                            Text("\(appController.userViewModel?.user?.birthmonth ?? "January") \(appController.userViewModel?.user?.birthday ?? 1)")
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
                            if (appController.userViewModel?.user?.wishlist.count == 0) {
                                Text("Nothing")
                            } else {
                                Text(wishlistString(wishlist: appController.userViewModel?.user?.wishlist ?? ["Nothing"]))
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
                            if (appController.userViewModel?.user?.about.count == 0 || appController.userViewModel?.user?.about.count == nil) {
                                Text("Blank")
                            } else {
                                Text(appController.userViewModel?.user?.about ?? "")
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
            Button("Sign out", role: .destructive) {
                GSignOut()
            }
        }
        .font(.system(size: 20))
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
    Text("Expect no data to load in this preview")
        .font(.headline)
        .foregroundStyle(.red)
    ProfileView().environmentObject(AppController())
}
