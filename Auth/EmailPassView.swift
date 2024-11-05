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
    
    @State var birthday: Date = Date()
    @State var firstName: String = ""
    @State var lastName: String = ""
    
   
    
    
    
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
                                Text("First")
                                TextField("", text: $firstName)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Last")
                                TextField("", text: $lastName)
                            }
                        }
                    }
                    
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Username")
                    TextField("", text: $appController.username)
                }
                
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                    SecureField("", text: $appController.password)
                }
                if(signingUp) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Birthday")
                        DatePicker("",selection: $birthday, displayedComponents: [.date])
                            .labelsHidden()
                    }
                    
                }
                
                //Depending on what view signIn / signUp buttoon
                Button(action: {signingUp ? signUp() : signIn() }) {
                    Text(signingUp ? "Sign Up" : "Sign In")
                        .frame(maxWidth: .infinity)
                }
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
                try await appController.signIn()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signUp() {
        Task {
            do {
                try await appController.signUp(first: firstName, last: lastName, email: appController.username, password: appController.password, birthday: birthday)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

    

#Preview {
    EmailPassView(signingUp: .constant(true))
}
