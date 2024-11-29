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
    var owner: UUID
    var members: [User]
    
    init(id: String? = nil, name: String, owner: UUID, members: [User]) {
        self.id = id
        self.name = name
        self.owner = owner
        self.members = members
    }
}
