//
//  AuthView.swift
//  giftApp
//
//  Created by user264039 on 10/11/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignInSwift

struct AuthView: View {
    
    
    let paddingAmount: CGFloat = 20
    @StateObject private var appController = AppController()
    @State private var signingUp = false
    
    var body: some View {
        VStack {
            
            VStack(spacing: 10) {
                
                VStack {
                    
                }
                
                GoogleSignInButton(scheme: .dark, style: .wide, state: .normal) {
                    GSignIn()
                }
                .cornerRadius(1)
                .border(.black)
                .padding(.horizontal)
                
                
                HStack {
                    VStack {
                        Divider()
                            .overlay(Color.black)
                    }
                    
                    Text("Or")
                        .padding(.horizontal)
                    
                    VStack {
                        Divider()
                            .overlay(Color.black)
                    }
                }
                .padding()
                
                EmailPassView(signingUp: $signingUp)
                
            }
            
           
            HStack {
                Text("Don't have an account?")
                Button("Sign Up") {
                    //This will switch views
                    signingUp.toggle()
                }
            }
            .padding()
        }
    }
    
   
    
 
    
    
    func GSignIn() {
        Task {
            do {
                try await appController.GSignIn()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

#Preview {
    AuthView()
}
