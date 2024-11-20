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
    
    
    func DDMMYYFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let rtnString = formatter.string(from: date)
        return rtnString
    }
    
    func writeGiftIdea() async throws{
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {
            print("user not authenticated")
            return
        }
        let query = db.collection("users").document(UID)
        let timeStampString = DDMMYYFormat(date: self.newGift.date)
        
        let giftData: [String: Any] = [
            "recipName": self.newGift.recipName,
            "date": self.newGift.date,
            "giftName": self.newGift.giftName
        ]
        
        do {
            //write timestamp field based on date selected
            //DateswithGifts->array->giftIdea (
            try await query.setData([
                "datesWithGifts": [
                    timeStampString: FieldValue.arrayUnion([
                       giftData
                    ])
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
