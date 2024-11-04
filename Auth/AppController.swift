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
    //username will just be email for now
    var username: String = ""
    var password: String = ""
    var isLoggedIn: Bool = false;
    @Published var userViewModel: UserViewModel?;
    
    
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
        try await initUserData()
        print("User's first name: \(self.userViewModel?.user?.firstName ?? "No name")")
        print("User's last name: \(self.userViewModel?.user?.lastName ?? "No name")")
    }
    
    func signUp(first: String, last: String, email: String, password: String, birthday: Date) async throws {
        //TODO: Make a struct for signUpInfo and pass that
        try await Auth.auth().createUser(withEmail: email, password: password)
        
        //signIn before adding to db for db rules
        try await Auth.auth().signIn(withEmail: email, password: password)
        
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {return}
        
        //create new user document
        try await db.collection("users").document(UID).setData([
           
              "firstName": first,
              "lastName": last,
              "email": email,
              "birthday": birthday,
              "wishlist": [],
              "preferences": []
        ])
        
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        
    }
    
    //call this after signing in
    func initUserData() async throws {
        
            self.userViewModel = UserViewModel()
            try await self.userViewModel?.fetchUserData()
        
    }
}

