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
    
    enum CodingKeys: CodingKey {
        case creator, comments
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        creator = try values.decode(String.self, forKey: .creator)
        comments = try values.decode([Comment].self, forKey: .comments)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(creator, forKey: .creator)
        try container.encode(comments, forKey: .comments)
        try super.encode(to: encoder)
    }
}

