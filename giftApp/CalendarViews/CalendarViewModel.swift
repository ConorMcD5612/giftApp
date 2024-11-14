//
//  CalendarViewModel.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import Foundation


class CalendarViewModel: ObservableObject {
    @Published var giftsDislayed: [GiftIdea]
    
    //var for creating a giftIdea in firestore
    @Published var newGift: GiftIdea
    
    
    //getting all giftIdeas for currentDay and all giftIdeas > currentDay
    
    //giftIdeas for the currentDate
    
    init() {
        self.newGift = GiftIdea()
        self.giftsDislayed = []
    }
    
}
