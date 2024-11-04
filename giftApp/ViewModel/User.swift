//
//  User.swift
//  giftApp
//
//  Created by user264039 on 10/30/24.
//

import FirebaseFirestore
import Foundation

class User: Codable, Identifiable {
    @DocumentID var userUID: String?
    var firstName: String;
    var lastName: String;
    var email: String;
    
    var birthday: Date?;
    var wishlist: [String]?;
    var preferences: [String]?;
    
    
    init(firstName: String = "", lastName: String = "", email: String = "", birthday: Date? = nil, userUID: String? = nil) {
         self.firstName = firstName
         self.lastName = lastName
         self.email = email
         self.birthday = birthday
         self.userUID = userUID
         self.wishlist = []
         self.preferences = []
     }
    
   
}
