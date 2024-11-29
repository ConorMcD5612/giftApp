//
//  GiftsBtnGroup.swift
//  giftApp
//
//  Created by user264039 on 11/26/24.
//

import SwiftUI

struct GiftsBtnGroup: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    func fetchUpcomingGifts() {
        Task {
            do {
                try await calendarViewModel.getGiftIdeasUpcoming()
            } catch {
                print("fetchUpComingGifts failed")
            }
        }
    }
    
    func fetchAllGifts() {
        Task {
            do {
                try await calendarViewModel.getGiftIdeasAll()
            } catch {
                print("fetchUpComingGifts failed")
            }
        }
    }
    
    var body: some View {
        HStack {
            Button(action: fetchUpcomingGifts) {
                Text("Upcoming")
            }
            Divider()
                .frame(height: 20)
            Button(action: fetchAllGifts ) {
                Text("All")
            }
           Spacer()
        }
        .padding(.horizontal, 10)
        
    }
}

#Preview {
    GiftsBtnGroup()
}
