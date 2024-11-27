//
//  AddRecipientView.swift
//  giftApp
//
//  Created by jmathies on 10/18/24.
//

import SwiftUI

struct AddRecipientView: View {
    @EnvironmentObject var settings: RecipientSettings
    
    // Used to pop view from NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = ""
    @State var birthday: String = ""
    @State var interests: String = ""
    @State var text: String = ""
    
    @State var confirmation: Bool = false
    
    @Binding var recipients: [Recipient]
    
    var MAX_NAME_LENGTH: Int = 32
    var MAX_BIRTHDAY_LENGTH: Int = 5
    var MAX_INTERESTS_LENGTH: Int = 320
    
    var body: some View {
        VStack {
            // User icon; uses first initial
            // Potentially add support for users to upload
            // a custom image for a person
            ZStack {
                Circle().frame(width: 150, height: 150)
                    .foregroundStyle(.teal)
                Text("\(name.prefix(1).uppercased())")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .bold()
            }.padding([.bottom])
                        
            VStack(spacing: 10) {
                VStack(spacing: 0) {
                    StyledTextField(title: "Name", text: "Enter name here", entry: $name, characterLimit: MAX_NAME_LENGTH, hideLimit: false, autoCapitalization: UITextAutocapitalizationType.words)
                    HStack {
                        Text("Required")
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                Divider()
                
                StyledTextField(title: "Birthday", text: "MM/DD", entry: $birthday, characterLimit: MAX_BIRTHDAY_LENGTH, hideLimit: true)
                
                Divider()
                
                StyledTextEditor(title: "Interests", entry: $interests, characterLimit: MAX_INTERESTS_LENGTH)
                Spacer()
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 10)
            
            .onChange(of: name) {
                // Removes any leading whitespaces and limits input to letters and spaces
                name.removeAll(where: { !($0.isLetter || $0.isWhitespace) })
                name = String(
                        name[(name.firstIndex(where: { !$0.isWhitespace }) ?? name.startIndex)...]
                    )
            }
            .onChange(of: birthday) {
                // TODO: Format input (make sure entered month & day is valid)
            }
            .navigationBarBackButtonHidden()
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if (name.count != 0 || birthday.count != 0 || interests.count != 0) {
                            confirmation = true
                        } else {
                            dismiss()
                        }
                    }.confirmationDialog("Are you sure you want to discard this new gift recipient?", isPresented: $confirmation, titleVisibility: .visible) {
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
                        recipients.append(Recipient(name: name, birthday: birthday, interests: interests))
                        settings.saveChanges()
                        dismiss()
                    }.disabled(name.count == 0)
                }
            }
        }
    }
}
