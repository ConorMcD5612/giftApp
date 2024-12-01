//
//  GroupGiftIdea.swift
//  giftApp
//
//  Created by jmathies on 11/30/24.
//

import SwiftUI

class GroupGiftIdea: RecipientGiftIdea {
    var creator: String
    var comments: [Comment]
    
    init(id: UUID = UUID(), name: String, description: String, link: String, creationDate: Date, giftingDate: Date?, creator: String, comments: [Comment]) {
        self.creator = creator
        self.comments = comments
        super.init(id: id, name: name, description: description, link: link, creationDate: creationDate, giftingDate: giftingDate)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

