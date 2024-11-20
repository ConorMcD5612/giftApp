//
//  CalendarViewModel.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class CalendarViewModel: ObservableObject {
    @Published var giftsDislayed: [GiftIdea]
    
    //var for creating a giftIdea in firestore
    @Published var newGift: GiftIdea
    
    @Published var selectedDateCal: Date
    
    
    //getting all giftIdeas for currentDay and all giftIdeas > currentDay
    
    //giftIdeas for the currentDate
    
    func writeGiftIdea() async throws{
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {
            print("user not authenticated")
            return
        }
        let query = db.collection("users").document(UID)
        
        
        do {
            //write timestamp field based on calendar date selected
            //map->array->map (giftIdeas)
            try await query.setData([
                "datesWithGifts:": [
                    Timestamp(date: self.newGift.date): FieldValue.arrayUnion([self.newGift])
                ]
            ], merge: true)
        } catch {
            print("Error with setting giftIdea")
        }
        
    }
    init() {
        self.newGift = GiftIdea()
        self.giftsDislayed = []
        self.selectedDateCal = Date()
    }
    
}
