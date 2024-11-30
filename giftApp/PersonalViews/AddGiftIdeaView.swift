//
//  AddGiftIdeaView.swift
//  giftApp
//
//  Created by jmathies on 11/25/24.
//

import SwiftUI

struct AddGiftIdeaView: View {
    @EnvironmentObject var settings: PersonalViewModel
    // Used to pop view from NavigationStack
    @Environment(\.dismiss) private var dismiss

    @State var name: String = ""
    @State var giftingDate: Date = Date()
    @State var description: String = ""
    @State var link: String = ""
    
    @State var confirmation: Bool = false
    @State var expectedGiftingDate: Bool = false
    
    @Binding var recipient: Recipient
    
    var MAX_NAME_LENGTH: Int = 32
    var MAX_DESCRIPTION_LENGTH: Int = 320
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 0) {
                StyledTextField(title: "Gift Idea", text: "Enter idea here", entry: $name, characterLimit: MAX_NAME_LENGTH, hideLimit: false, autoCapitalization: UITextAutocapitalizationType.none)
                HStack {
                    Text("Required")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
            
            Divider()
            
            VStack(spacing: 5) {
                HStack {
                    Text("Gifting Date")
                        .font(.system(size: 20))
                    Spacer()
                }
                if (expectedGiftingDate) {
                    HStack {
                        DatePicker("", selection: $giftingDate, displayedComponents: .date)
                            .frame(width: 135)
                        Button("Remove", role: .destructive) {
                            expectedGiftingDate = false
                        }
                        Spacer()
                    }
                } else {
                    HStack {
                        Button("Add") {
                            expectedGiftingDate = true
                        }
                        Spacer()
                    }
                }
            }.padding([.top])
            
            Divider()
            StyledTextField(title: "Link", text: "Enter link here", entry: $link, autoCapitalization: UITextAutocapitalizationType.none)
            
            Divider()
            StyledTextEditor(title: "Description", entry: $description, characterLimit: MAX_DESCRIPTION_LENGTH)
            
            if (recipient.interests.count != 0){
                Divider()
                HStack {
                    Text("\(recipient.name)'\(recipient.name.last?.lowercased() != "s" ? "s" : "") Interests")
                        .font(.system(size: 20))
                    Spacer()
                }
                HStack {
                    Text(recipient.interests)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            Spacer()
        }.padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
        
        .onChange(of: name) {
            // Removes any leading whitespaces and limits input to letters and spaces
            name = String(
                    name[(name.firstIndex(where: { !$0.isWhitespace }) ?? name.startIndex)...]
                )
        }
        .navigationBarBackButtonHidden()
        .toolbar() {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (name.count != 0 || description.count != 0) {
                        confirmation = true
                    } else {
                        dismiss()
                    }
                }.confirmationDialog("Are you sure you want to discard this new gift idea?", isPresented: $confirmation, titleVisibility: .visible) {
                    Button("Discard Changes", role: .destructive) {
                        confirmation = false
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {
                        confirmation = false
                    }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    recipient.giftIdeas.insert(RecipientGiftIdea(name: name, description: description, link: link, creationDate: Date.now, giftingDate: expectedGiftingDate ? giftingDate : nil), at: 0)
                    settings.saveChanges()
                    dismiss()
                }.disabled(name.count == 0)
            }
        }
    }
}
