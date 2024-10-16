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
    
    @StateObject private var appController = AppController()
    
    var body: some View {
        VStack {
            ZStack {
                
                
                
                
                VStack {
                    Section {
                        GoogleSignInButton(scheme: .light, style: .wide, state: .normal) {
                            GSignIn()
                        }
                        .padding(10)
                    }

                   
                    Form {
                       
                        Section {
                            VStack(alignment: .leading) {
                                Text("Username")
                                TextField("", text: $appController.username)
                                
                                Spacer()
                                
                                Text("Password")
                                SecureField("", text: $appController.password)
                                
                                
                                
                                Button( action: signIn) {
                                    Text("Sign In")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                
                            }
                            
                        }
                        .padding(10)
                        
                    }
                    .listRowSeparator(.hidden)
                    
                    
                }
                .textFieldStyle(.roundedBorder)
                
                Section {
                    HStack {
                        Text("Don't have an account?")
                        Button("Sign Up") {
                            signUp()
                        }
                    }
                }
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
