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
            
            //TODO: Divider component 
            Divider()
                .frame(width: 2)
                .overlay(Color.black)
           	 
            GiftItem(gift: GiftIdea(recipName: "brian jefferson", date: Date(), giftName: "gift card"))
            
        }
        
    }

}

#Preview {
    CalendarMainView()
}
