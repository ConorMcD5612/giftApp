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
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {
            print("user not authenticated")
            return
        }
        let query = db.collection("users").document(UID)
        
        //TODO: function to fetch datesWithGifts
        do {
            let data = try await query.getDocument().data()
            
            //type cast firebase data
            let datesWithGifts = data?["datesWithGifts"] as? [String: [[String: Any]]]
            
            
            //should be currentDate start of the day to next month
            let monthSeconds = 2.628e+6
            let monthFromToday = Date().addingTimeInterval(monthSeconds)
            let startOfToday = Calendar.current.startOfDay(for: Date())
            
            //a month from today for now
            let dateRange = startOfToday...monthFromToday
            
            //filter the dates for range
            var giftsInRange: [[String: Any]] = []
            datesWithGifts?.forEach ({ dateStr, dateArray in
                let date = stringToDate(dateStr: dateStr)
                print("date: \(date)")
                
                //contents of the dateArray is the gift maps
                if dateRange.contains(date) {
                    giftsInRange.append(contentsOf: dateArray)
                }
            })
            
            let newGiftsDisplayed = giftsInRange
            print("upcoming gifts: \(newGiftsDisplayed) ")
            //need to combine the arrays for each date
            DispatchQueue.main.async {
                self.giftsDisplayed = newGiftsDisplayed.map { gift in
                    //TODO: as? shouldn't matter though
                    //convert from timestamp
                    let date = gift["date"] as! Timestamp
                    return GiftIdea(recipName: gift["recipName"] as! String, date: date.dateValue(), giftName: gift["giftName"] as! String)
                }
            }

        } catch {
            print("get upcoming giftideas failed")
        }
        
    }
    
    //giftIdeas for the currentDate
    func getGiftIdeasCurrent() async throws {
        //query based on the calendar selected date
        let db = Firestore.firestore()
        guard let UID = Auth.auth().currentUser?.uid else {
            print("user not authenticated")
            return
        }
        let query = db.collection("users").document(UID)
        let timeStampString = dateToString(date: self.selectedDateCal)
        
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
                DispatchQueue.main.async {
                    self.giftsDisplayed = []
                }
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
        let timeStampString = dateToString(date: self.newGift.date)
        
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
    
    //util funcs
    
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let rtnString = formatter.string(from: date)
        return rtnString
    }
    
    //this is so I can use date comparisons
    func stringToDate(dateStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"
        if let rtnDate = formatter.date(from: dateStr){
            return rtnDate
        } else {
            print("str to date format error")
            return Date()
        }
    }
    
    
    init() {
        self.newGift = GiftIdea()
        self.giftsDisplayed = []
        self.selectedDateCal = Date()
    }
    
}
