//
//  User.swift
//  giftApp
//
//  Created by user264039 on 10/30/24.
//

import Foundation

class User {
    var name: String;
    var userUID: String;
    var email: String;
    var birthday: Date;
    
    var wishlist: [String]?;
    var prefrences: [String]?;
    
    
    init(name: String, email: String, birthday: Date, userUID: String) {
        self.name = name;
        self.email = email;
        self.birthday = birthday;
        self.userUID = userUID;
    }
    
}
