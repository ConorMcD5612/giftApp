//
//  AppController.swift
//  giftApp
//
//  Created by user264039 on 10/11/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn


class AppController: ObservableObject {
    //username will just be email for now
    var username: String = ""
    var password: String = ""
    
    
    func GSignIn() async throws{
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene else { return  }
        guard let rootViewController = await windowScene.windows.first?.rootViewController else { return }
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString else { return }
        let acessToken = result.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: acessToken)
        
        try await Auth.auth().signIn(with: credential)
    }
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

