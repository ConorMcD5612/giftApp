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
        
        
        VStack(spacing: 10) {
           
            HStack {
                Text("Create a gift idea")
                    .font(.title)
                    .foregroundStyle(.blue)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(10)
            
            
            HStack() {
               
                VStack(alignment: .leading, spacing: 5){
                    Text("Date:")
                        .font(.system(size: 20))
                    DatePicker("Date", selection: $calendarViewModel.newGift.date, displayedComponents: [.date])
                        .labelsHidden()
                }
                Spacer()
                    
            }
            .padding(.horizontal, 10)
            
            Divider()
                .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 2) {
                StyledTextField(title: "Recipient", text: "Enter the gift recipient's name", entry: $calendarViewModel.newGift.recipName, characterLimit: 64)
            }
            .padding(.horizontal, 10)
            
            Divider()
                .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 2) {
                StyledTextField(title: "Gift", text: "Enter gift idea details", entry: $calendarViewModel.newGift.giftName, characterLimit: 64)
            }
            .padding(.horizontal, 10)
            
            HStack(){
                Button("Cancel") {
                    creatingGift.toggle()
                }
                .buttonStyle(.bordered)
    
                Button(action: writeGiftIdea) {
                    Text("Save")
                }
                .buttonStyle(.borderedProminent)
            
                Spacer()
            }
            .padding(.horizontal, 10)
            
            Spacer()
        }
        .padding()
        .onDisappear {
            //pull down giftIdeas again
            Task {
                do {
                    try await calendarViewModel.getGiftIdeasAll()
                } catch {
                    print("giftcreateform ondisappear failed")
                }
            }
        }
    }
       
}

#Preview {
    GiftCreateForm(creatingGift: .constant(true))
        .environmentObject(CalendarViewModel())
}
