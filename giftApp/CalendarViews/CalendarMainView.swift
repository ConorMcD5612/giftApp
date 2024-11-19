//
//  CalendarMainView.swift
//  giftApp
//
//  Created by jmathies on 10/16/24.
//

import SwiftUI

struct CalendarMainView: View {
    @State var date: Date = Date()
    
    var body: some View {
        VStack {
            DatePicker(
                selection: $date,
                displayedComponents: [.date]
            ) {
                
            }
            .datePickerStyle(.graphical)
            
            Divider()
                .frame(height: 1)
                .overlay(Color.black)
                .padding(.vertical, 10)
            
            VStack(spacing: 10) {
                GiftItem(gift: GiftIdea(recipName: "brian jefferson", date: Date(), giftName: "gift card"))
                GiftItem(gift: GiftIdea(recipName: "brian jefferson", date: Date(), giftName: "gift card"))
                CreateGift()
            }
            
            Spacer()
        }
    }
}

#Preview {
    CalendarMainView()
        .environmentObject(CalendarViewModel())
}
