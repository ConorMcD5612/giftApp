//
//  ModifyGiftIdeaView.swift
//  giftApp
//
//  Created by jmathies on 11/27/24.
//

import SwiftUI

struct ModifyGiftIdeaView: View {
    @EnvironmentObject var settings: RecipientSettings
    // Used to pop view from NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    @Binding var recipient: Recipient
    @Binding var giftIdea: RecipientGiftIdea

    @State var name: String = ""
    @State var description: String = ""
    @State var link: String = ""
    
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
                    // Returns to GiftIdeasListView for recipient
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
        .toolbar() {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (name.count != 0 || description.count != 0) {
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
                    giftIdea.link = link
                    giftIdea.description = description
                    settings.saveChanges()
                    dismiss()
                }.disabled(name.count == 0)
            }
        }
        .onAppear() {
            name = giftIdea.name
            link = giftIdea.link
            description = giftIdea.description
        }
    }
}
