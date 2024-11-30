//
//  EditProfileView.swift
//  giftApp
//
//  Created by jmathies on 11/30/24.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    // Used to pop view from NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = ""
    @State var birthmonth: String = "January"
    @State var birthday: Int = 1
    
    @State var interests: [String] = []
        
    @State var addBirthday: Bool = false
    @State var cancelConfirmation: Bool = false
        
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
    
    func save() {
        appController.objectWillChange.send()
        appController.userViewModel?.user?.name = name
        Task {
            do {
                try await appController.userViewModel?.saveUserData()
            } catch {
                print("Write gift view didn't work")
            }
        }
        dismiss()
    }
    
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
                
                // TODO: Add place to insert wishlist items
                
                Divider()
                
                // TODO: Add place to insert interests
                
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
            .onChange(of: birthmonth) {
                if !VALID_DAYS[birthmonth]!.contains(birthday) {
                    birthday = 1
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        // TODO: Do checks to see if confirmation is needed
                        if (true) {
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
                    Button("Save", action: save).disabled(name.count == 0)
                }
            }
        }.onAppear() {
            name = appController.userViewModel?.user?.name ?? ""
        }
    }
}
