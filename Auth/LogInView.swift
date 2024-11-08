//
//  LogInView.swift
//  giftApp
//
//  Created by user264039 on 11/4/24.
//

import SwiftUI
import GoogleSignInSwift

struct LogInView: View {
    @StateObject private var appController = AppController()
    @Binding var signingUp: Bool
    
    
    var body: some View {
        VStack(spacing: 10) {
            
            
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
    
    func GSignIn() {
        Task {
            do {
                try await appController.GSignIn()
                signingUp.toggle()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    }


#Preview {
    LogInView(signingUp: .constant(true))
}
