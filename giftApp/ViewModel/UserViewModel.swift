//
//  UserViewModel.swift
//  giftApp
//
//  Created by user264039 on 10/30/24.
//

import Foundation
import Firebase

class UserViewModel: ObservableObject {
    //user optional
    @Published var user: User?;
    
    
    
    
    func fetchUserData() {
        let db = Firestore.firestore()
        
    }
    
    init() {
        self.user = nil;
        
    }
}
