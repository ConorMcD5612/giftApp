//
//  GiftItem.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import SwiftUI

struct GiftItem: View {
    let gift: GiftIdea
    
    
    func dayFromTimestamp(timestamp: Date) -> String {
        let day = Calendar.current.dateComponents([.day], from: timestamp).day
        return day != nil ? "\(day!)" : ""
    }
    
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Text("\(dayFromTimestamp(timestamp: gift.date))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Divider()
                .frame(width: 2)
                .overlay(Color.black)
            Spacer()
            VStack(alignment: .leading, spacing: 1){
                Text("Name:")
                    .fontWeight(.ultraLight)
                Text(gift.recipName)
                    .font(.system(size: 24))
            }
            Spacer()
            Divider()
                .frame(width: 2)
                .overlay(Color.black)
            
            Spacer()
            VStack(alignment: .leading, spacing: 1){
                Text("Gift:")
                    .fontWeight(.ultraLight)
                Text(gift.giftName)
                    .font(.system(size: 24))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 10)
    }
}

#Preview {
    GiftItem(gift: GiftIdea(recipName: "brian jefferson", date: Date(), giftName: "gift card"))
}
