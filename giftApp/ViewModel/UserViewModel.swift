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
                print("User data set \(self.user?.firstName ?? "name not found")")
            } else {
                print("userDocument does not exist/ does not match")
            }
            
        } catch {
            print("fetch user data error")
        }
    }
    
   
    
}
