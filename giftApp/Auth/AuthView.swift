//
//  AuthView.swift
//  giftApp
//
//  Created by user264039 on 10/11/24.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject private var appController = AppController()
    
    var body: some View {
        VStack {
            TextField("Username", text: $appController.username)
            TextField("Password", text: $appController.password)
            
            Button("Sign In") {
              signIn()
            }
            
            Text("Don't have an account?")
            Button("Sign Up") {
                signUp()
            }
        }
    }
    
    func signUp() {
        Task {
            do {
                try await appController.signUp()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                try await appController.signUp()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

#Preview {
    AuthView()
}
