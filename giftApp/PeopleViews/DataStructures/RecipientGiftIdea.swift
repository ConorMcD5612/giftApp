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
    var link: String
    var creationDate: Date
    var giftedDate: Date?
    
    init(id: UUID = UUID(), name: String, description: String, link: String, creationDate: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.link = link
        self.creationDate = creationDate
        self.giftedDate = nil
    }
}
