//
//  GiftItem.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import SwiftUI

struct GiftItem: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    let gift: GiftIdea
  
    func dayFromTimestamp(timestamp: Date) -> String {
        let day = Calendar.current.dateComponents([.day], from: timestamp).day
        return day != nil ? "\(day!)" : ""
    }
    
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(gift.recipName)
                    .fontWeight(.bold)
                Text(calendarViewModel.dateToString(date: gift.date))
                    .fontWeight(.ultraLight)
            }
            .frame(width: 100, alignment: .leading)
            
            Divider()
            VStack(alignment: .leading) {
                Text("Gift Idea: ")
                    .fontWeight(.ultraLight)
                Text(gift.giftName)
                    
            }
            .padding(.horizontal, 10)
            Spacer()
            
            }
            .lineLimit(1)
            
        }
        
    
}

#Preview {
    GiftItem(gift: GiftIdea(recipName: "brian jefferson", date: Date(), giftName: "gift card"))
        .environmentObject(CalendarViewModel())
}
