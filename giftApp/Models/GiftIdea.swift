//
//  File.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import Foundation


struct GiftIdea: Codable, Identifiable {
    var id = UUID()
    var recipName: String
    var date: Date
    var giftName: String
    
    init(recipName: String, date: Date, giftName: String) {
        self.recipName = recipName
        self.date = date
        self.giftName = giftName
    }
    
    init() {
        self.recipName = ""
        self.date = Date()
        self.giftName = ""
        
    }
}
