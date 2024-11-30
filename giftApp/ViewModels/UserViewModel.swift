//
//  UserViewModel.swift
//  giftApp
//
//  Created by user264039 on 10/30/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    //user optional
    @Published var user: User?
    
    //documentID is set to UID
    func fetchUserData() async throws{
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {
            print("user not authenticated")
            return
        }
        print("\(UID)")
        let query = db.collection("users").document(UID)
        
        do {
            let document = try await query.getDocument()
            if let userData = try? document.data(as: User.self) {
                //going to have to change this to not 1:1 matching db doc
                self.user = userData
                print("User data acquired for \(self.user?.email ?? "email not found")")
            } else {
                print("userDocument does not exist / does not match")
                try await Auth.auth().currentUser?.delete()
                try Auth.auth().signOut()
                
            }
        } catch {
            print("fetch user data error")
        }
    }
    
    func saveUserData() async throws {
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {
            print("user not authenticated")
            return
        }
        print("\(UID)")
        let query = db.collection("users").document(UID)
        
        do {
            //write timestamp field based on date selected
            //DateswithGifts->array->giftIdea (
            try await query.setData([
                "name": user!.name,
                "birthmonth": user!.birthmonth as Any,
                "birthday": user!.birthday as Any,
                "wishlist": user!.wishlist as Any,
                "about": user!.about
            ], merge: true)
            print("User data saved")
        } catch {
            print("Error with setting giftIdea")
        }
    }
}
