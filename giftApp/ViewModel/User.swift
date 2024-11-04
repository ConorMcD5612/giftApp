//
//  User.swift
//  giftApp
//
//  Created by user264039 on 10/30/24.
//

import Foundation

class User {
    var firstName: String;
    var lastName: String;
    var userUID: String;
    var email: String;
    var birthday: Date;
    
    var wishlist: [String]?;
    var prefrences: [String]?;
    
    
    init(firstName: String, lastName: String, email: String, birthday: Date, userUID: String) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.birthday = birthday;
        self.userUID = userUID;
    }
}
