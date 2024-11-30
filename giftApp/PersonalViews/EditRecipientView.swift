//
//  ModifyRecipientView.swift
//  giftApp
//
//  Created by jmathies on 11/26/24.
//

import SwiftUI

struct EditRecipientView: View {
    @EnvironmentObject var settings: PersonalViewModel
    // Used to pop view from NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    @Binding var recipient: Recipient
    
    @State var name: String = ""
    
    @State var birthmonth: String = "January"
    @State var birthday: Int = 1
    
    @State var interests: String = ""
        
    @State var addBirthday: Bool = false
    @State var cancelConfirmation: Bool = false
    @State var deleteConfirmation: Bool = false
        
    var MAX_NAME_LENGTH: Int = 32
    var MAX_INTERESTS_LENGTH: Int = 320
    
    var VALID_MONTHS: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    var VALID_DAYS: [String : [Int]] = [
        "January": Array(1...31),
        "February": Array(1...29),
        "March": Array(1...31),
        "April": Array(1...30),
        "May": Array(1...31),
        "June": Array(1...30),
        "July": Array(1...31),
        "August": Array(1...31),
        "September": Array(1...30),
        "October": Array(1...31),
        "November": Array(1...30),
        "December": Array(1...31)
    ]
    
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
            }.padding([.top, .bottom])
                        
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
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Birthday")
                            .font(.system(size: 20))
                        Spacer()
                    }
                    if (addBirthday) {
                        HStack {
                            HStack {
                                Picker(selection: $birthmonth, label: EmptyView()) {
                                    ForEach(VALID_MONTHS, id: \.self) {
                                        Text($0)
                                    }
                                }
                                Picker(selection: $birthday, label: EmptyView()) {
                                    ForEach(VALID_DAYS[birthmonth] ?? [], id: \.self) {
                                        Text("\($0)")
                                        
                                    }
                                }
                            }.overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.gray)
                                    .opacity(0.2)
                            )
                            Button("Remove", role: .destructive) {
                                addBirthday = false
                            }
                            Spacer()
                        }
                    } else {
                        HStack {
                            Button("Add") {
                                addBirthday = true
                            }
                            Spacer()
                        }
                    }
                }
                
                Divider()
                
                StyledTextEditor(title: "Interests", entry: $interests, characterLimit: MAX_INTERESTS_LENGTH)
                Spacer()
                Button("Delete Recipient", role: .destructive) {
                    deleteConfirmation = true
                }.confirmationDialog("Are you sure you want to delete this gift recipient?\n All of their info and gift ideas will be deleted!", isPresented: $deleteConfirmation, titleVisibility: .visible) {
                    Button("Delete", role: .destructive) {
                        deleteConfirmation = false
                        settings.remove(recipient: recipient)
                        settings.saveChanges()
                        // Returns to root view
                        settings.path.removeAll()
                    }
                    Button("Cancel", role: .cancel) {
                        deleteConfirmation = false
                    }
                }
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
            .onChange(of: birthmonth) {
                if !VALID_DAYS[birthmonth]!.contains(birthday) {
                    birthday = 1
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Editing Recipient").font(.headline)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if (name != recipient.name || interests != recipient.interests || (addBirthday && (birthmonth != recipient.birthmonth || birthday != recipient.birthday) || (!addBirthday && recipient.birthday != nil))) {
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
                        // Required to push changes to prior views
                        settings.objectWillChange.send()
                        recipient.name = name
                        if addBirthday {
                            recipient.birthmonth = birthmonth
                            recipient.birthday = birthday
                        } else {
                            recipient.birthmonth = nil
                            recipient.birthday = nil
                        }
                        recipient.interests = interests

                        settings.saveChanges()
                        dismiss()
                    }.disabled(name.count == 0)
                }
            }
        }.onAppear() {
            name = recipient.name
            if recipient.birthmonth != nil && recipient.birthday != nil {
                addBirthday = true
                birthmonth = recipient.birthmonth!
                birthday = recipient.birthday!
            }
            interests = recipient.interests
        }
    }
}
