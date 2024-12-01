//
//  Comment.swift
//  giftApp
//
//  Created by jmathies on 11/30/24.
//

import SwiftUI

struct Comment: Codable {
    // id of user who posted the comment
    var poster: String
    var timestamp: Date
    var text: String
    
    init(poster: String, timestamp: Date, text: String) {
        self.poster = poster
        self.timestamp = timestamp
        self.text = text
    }
}
