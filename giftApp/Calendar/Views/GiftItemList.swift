//
//  GiftItemList.swift
//  giftApp
//
//  Created by user264039 on 11/26/24.
//

import SwiftUI

struct GiftItemList: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
 
    var body: some View {
        VStack(spacing: 10) {
                List(calendarViewModel.giftsDisplayed) {
                giftIdea in
                GiftItem(gift: giftIdea)
            }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    GiftItemList()
}
