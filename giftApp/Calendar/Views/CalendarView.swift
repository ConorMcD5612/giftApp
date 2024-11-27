//
//  CalendarView.swift
//  giftApp
//
//  Created by user264039 on 11/26/24.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    var body: some View {
        //Wanted to use the datepicker as the main way of rendering giftIdeas on different dates. I would have to write my own
        DatePicker(
            selection: $calendarViewModel.selectedDateCal,
            displayedComponents: [.date]
        ) {
            
        }
        .datePickerStyle(.graphical)
        .padding()
        Divider()
            .frame(height: 1)
            .overlay(Color.black)
            .padding(.top, 10)
    }
}

#Preview {
    CalendarView()
}
