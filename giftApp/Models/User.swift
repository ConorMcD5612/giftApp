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
    
    var birthmonth: String?
    var birthday: Int?
    
    var wishlist: [String]
    var about: String
    
    var groups: [String]
    
    init(id: String? = nil, name: String, email: String, birthmonth: String? = nil, birthday: Int? = nil, wishlist: [String] = [], about: String = "", groups: [String] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.birthmonth = birthmonth
        self.birthday = birthday
        self.wishlist = wishlist
        self.about = about
        self.groups = groups
    }
}
