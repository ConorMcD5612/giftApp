//
//  Person.swift
//  giftApp
//
//  Created by jmathies on 11/19/24.
//

class Person: Identifiable {
    var name: String
    var birthday: Int
    var birthmonth: Int
    var interests: String
    
    init(name: String, birthday: Int, birthmonth: Int, interests: String) {
        self.name = name
        self.birthday = birthday
        self.birthmonth = birthmonth
        self.interests = interests
    }
}
