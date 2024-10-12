//
//  AppController.swift
//  giftApp
//
//  Created by user264039 on 10/11/24.
//

import SwiftUI
import FirebaseAuth


class AppController: ObservableObject {
    //username will just be email for now
    var username: String = ""
    var password: String = ""
    
    
    func signIn() async throws{
        try await Auth.auth().signIn(withEmail: username, password: password)
    }
    
    func signUp() async throws {
        try await Auth.auth().createUser(withEmail: username, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }

}

