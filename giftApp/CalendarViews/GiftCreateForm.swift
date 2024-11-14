//
//  GiftCreateForm.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import SwiftUI

struct GiftCreateForm: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    var body: some View {
        HStack {
            DatePicker("Date", selection: $calendarViewModel.newGift.date)
            TextField("Recipent: ", text: $calendarViewModel.newGift.recipName)
            TextField("Gift: ", text: $calendarViewModel.newGift.giftName)
        }
    }
}

#Preview {
    GiftCreateForm()
}
