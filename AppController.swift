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
import Firebase


class AppController: ObservableObject {
    @Published var userViewModel: UserViewModel?;
    
    var email: String = ""
    var password: String = ""
    
    
    func GSignIn() async throws{
        do {
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
            
            let googleUserData = result.user.profile
            print("\(googleUserData?.name ?? "Name doesn't work")")
            
            //need to sign in first for auth rules
            try await Auth.auth().signIn(with: credential)
            
            
            //put gUserData in firestore
            let db = Firestore.firestore()
            guard let UID = Auth.auth().currentUser?.uid else {return}
            let query = db.collection("users").document(UID)
            
            
            let document = try await query.getDocument()
            
            if !document.exists {
                try await db.collection("users").document(UID).setData([
                    "name": googleUserData?.givenName ?? "",
                    "email": googleUserData?.email ?? "",
                    "wishlist": [],
                    "about": []
                ])
            }
            print("Gsignin worked")
        } catch {
            print("Gsignin did not work")
        }
    }
    
    func GSignOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
        email = ""
        password = ""
        userViewModel?.user?.name = ""
        userViewModel?.user?.email = ""
        userViewModel?.user?.birthmonth = nil
        userViewModel?.user?.birthday = nil
        userViewModel?.user?.wishlist = []
        userViewModel?.user?.about = ""
    }
    
    func signIn() async throws{
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signUp(name: String, email: String, password: String) async throws {
        //TODO: Make a struct for signUpInfo and pass that
        try await Auth.auth().createUser(withEmail: email, password: password)
        
        //signIn before adding to db for db rules
        try await Auth.auth().signIn(withEmail: email, password: password)
        
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {return}
        
        //create new user document
        try await db.collection("users").document(UID).setData([
            "name": name,
            "email": email,
            "wishlist": [],
            "about": ""
        ])
    }
    
    //call this after signing in
    func initUserData() async throws {
        let userViewModel = UserViewModel()
        
        do {
            try await userViewModel.fetchUserData()
            self.objectWillChange.send()
        } catch {
            print("initUserData failed")
        }
        
        DispatchQueue.main.async {
            self.userViewModel = userViewModel
        }
    }
}

