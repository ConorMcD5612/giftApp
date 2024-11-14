//
//  File.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import Foundation

struct GiftIdea: Decodable {
    let recipName: String
    let date: Date
    let giftName: String
    
    
    init(recipName: String, date: Date, giftName: String) {
        self.recipName = recipName
        self.date = date
        self.giftName = giftName
    }
}
