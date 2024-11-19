//
//  GiftCreateForm.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import SwiftUI

struct GiftCreateForm: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    @Binding var creatingGift: Bool
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Date:")
                DatePicker("Date", selection: $calendarViewModel.newGift.date, displayedComponents: [.date])
                    .labelsHidden()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Recipient:")
                TextField("", text: $calendarViewModel.newGift.recipName)
                    .border(Color.black, width: 1)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Gift:")
                TextField("", text: $calendarViewModel.newGift.giftName)
                    .border(Color.black, width: 1)
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black)
        }
        .padding()
    }
}

#Preview {
    GiftCreateForm(creatingGift: .constant(true))
}
