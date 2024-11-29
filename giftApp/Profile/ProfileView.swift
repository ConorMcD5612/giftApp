//
//  ProfileView.swift
//  giftApp
//
//  Created by user264039 on 11/28/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appController: AppController
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle().frame(width: 150, height: 150)
                    .foregroundStyle(.teal)
                Text("\(appController.userViewModel?.user?.firstName.prefix(1).uppercased() ?? "")")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .bold()
            }.padding([.bottom])
            HStack {
                Text("Name:")
                    .fontWeight(.light)
                Text(appController.userViewModel?.user?.firstName ?? "")
                Text(appController.userViewModel?.user?.lastName ?? "")
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Birthday:")
                    .fontWeight(.light)
                Text(formatDate(date: appController.userViewModel?.user?.birthday ?? Date()))
                Spacer()
            }
            
            Divider()
            
            HStack {
                Button("Sign out") {
                    GSignOut()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                Spacer()
            }
            
            Spacer()
        }
        .padding()
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
    ProfileView()
}
