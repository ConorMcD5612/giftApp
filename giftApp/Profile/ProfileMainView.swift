//
//  SwiftUIView.swift
//  giftApp
//
//  Created by user264039 on 10/24/24.
//

import SwiftUI

struct ProfileMainView: View {
    @EnvironmentObject var appController: AppController
    
    var body: some View {
        VStack {
            Image(systemName: "person")
                .font(.title)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.black, lineWidth: 4)
                }
                .shadow(radius: 5)
            Button("Sign out") {
                GSignOut()
            }
            Text(appController.userViewModel?.user?.firstName ?? "")
            Text(appController.userViewModel?.user?.lastName ?? "")
            
            
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
    ProfileMainView()
}
	
