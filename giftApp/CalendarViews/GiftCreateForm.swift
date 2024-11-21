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
    
    
    func writeGiftIdea() {
        creatingGift.toggle()
        Task {
            do {
                try await calendarViewModel.writeGiftIdea()
            } catch {
                print("Write gift view didn't work")
            }
        }
    }
    var body: some View {
        
        VStack(spacing: 0) {
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
                        .autocapitalization(.none)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Gift:")
                    TextField("", text: $calendarViewModel.newGift.giftName)
                        .border(Color.black, width: 1)
                        .autocapitalization(.none)
                }
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black)
            }
            .padding(.horizontal, 10)
            HStack {
                Button(action: {creatingGift.toggle()}) {
                    Text("Close")
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Divider()
                    .frame(width: 1, height: 50)
                    .overlay(Color.black)
                    
                Button(action: writeGiftIdea) {
                    Text("Save")
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black)
            }
            .padding(.horizontal, 10)

        }
       
    }
}

#Preview {
    GiftCreateForm(creatingGift: .constant(true))
        .environmentObject(CalendarViewModel())
}
