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
    @Published var giftsDisplayed: [GiftIdea]
    
    //var for creating a giftIdea in firestore
    @Published var newGift: GiftIdea
    
    @Published var selectedDateCal: Date
    
    
    //getting all giftIdeas >= currentDay
    func getGiftIdeasUpcoming() async throws {
        
    }
    
    //giftIdeas for the currentDate
    //maybe change to sub collection?
    func getGiftIdeasCurrent() async throws {
        //query based on the calendar selected date
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {
            print("user not authenticated")
            return
        }
        let query = db.collection("users").document(UID)
        let timeStampString = DDMMYYFormat(date: self.selectedDateCal)
        
        do {
            let data = try await query.getDocument().data()
            
            //type cast firebase data
            let datesWithGifts = data?["datesWithGifts"] as? [String: [[String: Any]]]
                
            
            if let gifts = datesWithGifts?[timeStampString]{
                DispatchQueue.main.async {
                    self.giftsDisplayed = gifts.map { gift in
                        //TODO: as? shouldn't matter though
                        //convert from timestamp
                        let date = gift["date"] as! Timestamp
                        return GiftIdea(recipName: gift["recipName"] as! String, date: date.dateValue(), giftName: gift["giftName"] as! String)
                    }
                }
                print(self.giftsDisplayed)
            } else {
                print("no giftIdeas for this date")
            }
        } catch {
            print("getting doc data failed giftIdeasCurrent")
        }
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
    
    //util func
    func DDMMYYFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let rtnString = formatter.string(from: date)
        return rtnString
    }
    
    
    init() {
        self.newGift = GiftIdea()
        self.giftsDisplayed = []
        self.selectedDateCal = Date()
    }
    
}
