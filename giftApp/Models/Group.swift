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
    // UID of user that created the group
    var ownerID: String
    // Contains a list of ids that can be used to get data
    var members: [String]
    
    var memberGiftideas: [String: [GroupGiftIdea]]
    
    init(id: String? = nil, name: String, owner: String, members: [String], memberGiftideas: [String: [GroupGiftIdea]]) {
        self.id = id
        self.name = name
        self.ownerID = owner
        self.members = members
        self.memberGiftideas = memberGiftideas
    }
}
