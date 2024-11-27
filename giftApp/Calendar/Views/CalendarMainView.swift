//
//  CalendarMainView.swift
//  giftApp
//
//  Created by jmathies on 10/16/24.
//

import SwiftUI

struct CalendarMainView: View {
    
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @State var creatingGift = false;
    
    
    var body: some View {
        VStack {
            if creatingGift {
                GiftCreateForm(creatingGift: $creatingGift)
            } else {
                CalendarView()
                GiftItemList()
                CreateGiftBtn(creatingGift: $creatingGift)
                Spacer()
            }

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
