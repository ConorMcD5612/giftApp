//
//  User.swift
//  giftApp
//
//  Created by user264039 on 10/30/24.
//

import FirebaseFirestore
//import Foundation

class User: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String;
    
    var birthmonth: String?
    var birthday: Int?
    
    var wishlist: [String]
    var about: String
    
    var groups: [DocumentReference]
    
    init(uid: String? = nil, name: String, email: String, birthmonth: String? = nil, birthday: Int? = nil, wishlist: [String] = [], about: String = "", groups: [DocumentReference] = []) {
        self.id = uid
        self.name = name
        self.email = email
        self.birthmonth = birthmonth
        self.birthday = birthday
        self.wishlist = wishlist
        self.about = about
        self.groups = groups
    }
}
