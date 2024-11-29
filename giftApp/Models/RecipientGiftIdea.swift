//
//  GiftIdea.swift
//  giftApp
//
//  Created by jmathies on 11/22/24.
//

import SwiftUI

class RecipientGiftIdea: Identifiable, Codable {
    var id: UUID
    var name: String
    var description: String
    
    // Web address to site where gift can be purchased
    var link: String
    
    // Date the idea was created
    var creationDate: Date
    
    // Expected date for when the gift will be gifted
    var giftingDate: Date?
    
    init(id: UUID = UUID(), name: String, description: String, link: String, creationDate: Date, giftingDate: Date?) {
        self.id = id
        self.name = name
        self.description = description
        self.link = link
        self.creationDate = creationDate
        self.giftingDate = giftingDate
    }
}
