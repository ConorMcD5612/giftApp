//
//  ModifyGiftIdeaView.swift
//  giftApp
//
//  Created by jmathies on 11/27/24.
//

import SwiftUI

struct EditGiftIdeaView: View {
    @EnvironmentObject var settings: PersonalViewModel
    // Used to pop view from NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    @Binding var recipient: Recipient
    @Binding var giftIdea: RecipientGiftIdea

    @State var name: String = ""
    @State var giftingDate: Date = Date()
    @State var description: String = ""
    @State var link: String = ""
    
    @State var expectedGiftingDate: Bool = false
    @State var cancelConfirmation: Bool = false
    @State var deleteConfirmation: Bool = false
        
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
            
            Spacer()
            
            Button("Delete Gift Idea", role: .destructive) {
                deleteConfirmation = true
            }.confirmationDialog("Are you sure you want to delete this gift idea?", isPresented: $deleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    deleteConfirmation = false
                    recipient.remove(giftIdea: giftIdea)
                    settings.saveChanges()
                    // Returns to RecipientView for recipient
                    settings.path.removeLast(2)
                }
                Button("Cancel", role: .cancel) {
                    deleteConfirmation = false
                }
            }
        }.padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
        
        .onChange(of: name) {
            // Removes any leading whitespaces and limits input to letters and spaces
            name = String(
                    name[(name.firstIndex(where: { !$0.isWhitespace }) ?? name.startIndex)...]
                )
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Editing Gift Idea").font(.headline)
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (name != giftIdea.name || link != giftIdea.link || description != giftIdea.description || expectedGiftingDate && giftingDate != giftIdea.giftingDate || !expectedGiftingDate && giftIdea.giftingDate != nil) {
                        cancelConfirmation = true
                    } else {
                        dismiss()
                    }
                }.confirmationDialog("Are you sure you want to discard these changes?", isPresented: $cancelConfirmation, titleVisibility: .visible) {
                    Button("Discard Changes", role: .destructive) {
                        cancelConfirmation = false
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {
                        cancelConfirmation = false
                    }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    giftIdea.name = name
                    if expectedGiftingDate {
                        giftIdea.giftingDate = giftingDate
                    } else {
                        giftIdea.giftingDate = nil
                    }
                    giftIdea.link = link
                    giftIdea.description = description
                    settings.saveChanges()
                    dismiss()
                }.disabled(name.count == 0)
            }
        }
        .onAppear() {
            name = giftIdea.name
            if (giftIdea.giftingDate != nil) {
                expectedGiftingDate = true
                giftingDate = giftIdea.giftingDate!
            }
            link = giftIdea.link
            description = giftIdea.description
        }
    }
}
