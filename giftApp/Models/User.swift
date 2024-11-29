//
//  User.swift
//  giftApp
//
//  Created by user264039 on 10/30/24.
//

import FirebaseFirestore
//import Foundation

class User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String;
    
    var birthday: Date?;
    var wishlist: [String]?;
    var interests: [String]?;
    
    init(id: String? = nil, name: String = "", email: String = "", birthday: Date? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.birthday = birthday
        self.wishlist = []
        self.interests = []
    }
}
