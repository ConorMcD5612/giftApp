//
//  Group.swift
//  giftApp
//
//  Created by jmathies on 11/27/24.
//

import FirebaseFirestore

class Group: Codable {
    @DocumentID var id: String?
    
    var name: String

    // Contains a list of ids that can be used to get data
    var members: [String]
    
    var memberGiftIdeas: [String: [GroupGiftIdea]]
    
    init(id: String? = nil, name: String, members: [String], memberGiftideas: [String: [GroupGiftIdea]] = [:]) {
        self.id = id
        self.name = name
        self.members = members
        self.memberGiftIdeas = memberGiftideas
        
        for memberID in members {
            memberGiftIdeas[memberID] = []
        }
    }
}
