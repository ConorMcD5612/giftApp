//
//  Comment.swift
//  giftApp
//
//  Created by jmathies on 11/30/24.
//

import SwiftUI

struct Comment: Codable {
    // id of user who posted the comment
    var posterID: String
    var timestamp: Date
    var text: String
    
    init(posterID: String, timestamp: Date, text: String) {
        self.posterID = posterID
        self.timestamp = timestamp
        self.text = text
    }
}
