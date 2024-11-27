//
//  Person.swift
//  giftApp
//
//  Created by jmathies on 11/19/24.
//

import SwiftUICore

class Recipient: Codable {
    var id: UUID
    var name: String
    var birthday: String
    var interests: String
    
    var giftIdeas: [RecipientGiftIdea]
    
    init(id: UUID = UUID(), name: String, birthday: String, interests: String)
    {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.interests = interests
        self.giftIdeas = []
    }
    
    func remove(giftIdea: RecipientGiftIdea) {
        for i in 0...(giftIdeas.count - 1) {
            if giftIdeas[i].id == giftIdea.id {
                giftIdeas.remove(at: i)
            }
        }
    }
}

