//
//  EmailPassView.swift
//  giftApp
//
//  Created by user264039 on 10/17/24.
//

import SwiftUI

struct EmailPassView: View {
    
    @EnvironmentObject private var appController: AppController
    @Binding var signingUp: Bool
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage: String = ""
    
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
                if(signingUp){
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Name")
                                TextField("", text: $name)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email Address")
                    TextField("", text: $email)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                    SecureField("", text: $password)
                        .autocapitalization(.none)
                }
                
                //Depending on what view signIn / signUp buttoon
                Button(action: {signingUp ? signUp() : signIn() }) {
                    Text(signingUp ? "Sign Up" : "Sign In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                Text(errorMessage)
                    .font(.system(size: 14))
                    .foregroundStyle(.red)
            }
            .padding(30)
            .textFieldStyle(.roundedBorder)
            
        }
        .frame(height: 200)
    }
    
    func signIn() {
        appController.email = email
        appController.password = password
        Task {
            do {
                try await appController.signIn()
            } catch {
                errorMessage = "Incorrect email address or password"
                print(error.localizedDescription)
            }
        }
    }
    
    func signUp() {
        appController.email = email
        appController.password = password
        Task {
            do {
                try await appController.signUp(name: name, email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
}

    

#Preview {
    EmailPassView(signingUp: .constant(true))
}
