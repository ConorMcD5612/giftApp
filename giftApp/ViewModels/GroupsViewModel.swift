//
//  GroupsSettings.swift
//  giftApp
//
//  Created by jmathies on 11/27/24.
//

import SwiftUICore

class GroupsViewModel: ObservableObject {
    enum Views {
        case placeholder
    }
    
    @Published var groups: [Recipient]
    @Published var path: [Views]
    @Published var selectedGroup: Group?
    
    init() {
        self.groups = []
        self.path = []
        self.selectedGroup = nil
    }
    
//    func remove(recipient: Recipient) {
//        for i in 0...(recipients.count - 1) {
//            if recipients[i].id == recipient.id {
//                recipients.remove(at: i)
//            }
//        }
//    }
}
