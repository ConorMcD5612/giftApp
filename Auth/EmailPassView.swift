//
//  EmailPassView.swift
//  giftApp
//
//  Created by user264039 on 10/17/24.
//

import SwiftUI

struct EmailPassView: View {
    
    @StateObject private var appController = AppController()
    @Binding var signingUp: Bool
    
    
    var body: some View {
        ZStack {
            //this causes shadows around text input idk how to fix so leaving for now
            RoundedRectangle(cornerRadius: 1)
                .fill(.gray)
                .opacity(0.1)
                .shadow(color: .black, radius: 15)
                .overlay {
                    RoundedRectangle(cornerRadius: 1)
                        .stroke(.black, lineWidth: 1)
                }
                .padding()
                
                
                
            VStack(alignment: .leading, spacing: 15) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Username")
                    TextField("", text: $appController.username)
                }
              
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                    SecureField("", text: $appController.password)
                }
                
                
                
                //Depending on what view signIn / signUp buttoon
                Button(signingUp ? "Sign Up" : "Sign In") {
                    signingUp ? signUp() : signIn()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                
            }
            .padding(30)
            .textFieldStyle(.roundedBorder)
            
        }
        .frame(height: 200)
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
    
    func signUp() {
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
    EmailPassView(signingUp: .constant(true))
}
