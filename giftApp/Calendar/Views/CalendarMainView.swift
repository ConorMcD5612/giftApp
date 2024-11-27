//
//  CalendarMainView.swift
//  giftApp
//
//  Created by jmathies on 10/16/24.
//

import SwiftUI

struct CalendarMainView: View {
    
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            DatePicker(
                selection: $calendarViewModel.selectedDateCal,
                displayedComponents: [.date]
            ) {
                
            }
            .datePickerStyle(.graphical)
            
            Divider()
                .frame(height: 1)
                .overlay(Color.black)
                .padding(.vertical, 10)
            
            VStack(spacing: 10) {		
	                ForEach(calendarViewModel.giftsDisplayed) {
                    giftIdea in
                    GiftItem(gift: giftIdea)
                }
                CreateGift()
            }
            
            Spacer()
        }
        
        .onAppear() {
            Task {
                do {
                    try await calendarViewModel.getGiftIdeasUpcoming()
                } catch {
                    print("on appear calendarmainview failed")
                }
            }
        }
        .onChange(of: calendarViewModel.selectedDateCal) {
            if Calendar.current.startOfDay(for: calendarViewModel.selectedDateCal) == Calendar.current.startOfDay(for: Date()) {
                Task {
                    do {
                        try await calendarViewModel.getGiftIdeasUpcoming()
                    } catch {
                        print("upcoming calendarmainview")
                    }
                }
            } else {
                Task {
                    do {
                        try await calendarViewModel.getGiftIdeasCurrent()
                    } catch {
                        print("getGiftIdeasCurrent failed in onChange")
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarMainView()
        .environmentObject(CalendarViewModel())
}
