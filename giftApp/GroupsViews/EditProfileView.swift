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
    
    @State var wishlistItem: String = ""
    @State var wishlist: [String] = []
    @State var alreadyAddedItem: Bool = false
    
    @State var about: String = ""
        
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
        if (addBirthday) {
            appController.userViewModel?.user?.birthmonth = birthmonth
            appController.userViewModel?.user?.birthday = birthday
        } else {
            appController.userViewModel?.user?.birthmonth = nil
            appController.userViewModel?.user?.birthday = nil
        }
        
        appController.userViewModel?.user?.wishlist = wishlist
        appController.userViewModel?.user?.about = about
        
        Task {
            do {
                try await appController.userViewModel?.saveUserData()
            } catch {
                print("Write gift view didn't work")
            }
        }
        dismiss()
    }
    
    func wishlistString() -> String {
        var string = ""
        
        for item in wishlist {
            string += item
            if (wishlist.count > 1 && wishlist.last != item) {
                string += ", "
            }
        }
        
        return string
    }
    
    var body: some View {
        ScrollView {
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
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("Wishlist")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        if (wishlist.count != 0) {
                            ForEach(wishlist, id: \.self) { item in
                                HStack(spacing: 0) {
                                    Text("- \(item)")
                                    Spacer()
                                }
                            }.font(.system(size: 20))
                        }
                        HStack {
                            StyledTextField(text: "Enter item here", entry: $wishlistItem, characterLimit: 64)
                                .frame(width: 180)
                            Button("Add") {
                                alreadyAddedItem = false
                                if (wishlistItem != "" && !wishlist.contains(wishlistItem)) {
                                    let index = wishlist.firstIndex(where: {$0 > wishlistItem})
                                    wishlist.insert(wishlistItem, at: index ?? wishlist.endIndex)
                                    wishlistItem = ""
                                } else {
                                    alreadyAddedItem = true
                                }
                            }
                            Button("Remove", role: .destructive) {
                                alreadyAddedItem = false
                                wishlist.removeAll(where: {$0 == wishlistItem})
                                wishlistItem = ""
                            }
                            Spacer()
                        }
                        if (alreadyAddedItem) {
                            HStack {
                                Text("Item already added to wishlist!")
                                    .foregroundStyle(.red)
                                    .font(.system(size: 16))
                                Spacer()
                            }
                        }
                    }
                    
                    Divider()
                    
                    StyledTextEditor(title: "About", entry: $about, characterLimit: 320)
                    
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
                .toolbarTitleDisplayMode(.inline)
                .toolbar() {
                    ToolbarItem(placement: .principal) {
                        Text("Editing Profile").font(.headline)
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            if (name != appController.userViewModel?.user?.name || (addBirthday && (birthday != appController.userViewModel?.user?.birthday || birthmonth != appController.userViewModel?.user?.birthmonth)) || wishlist != appController.userViewModel?.user?.wishlist || about != appController.userViewModel?.user?.about) {
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
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .onAppear() {
            name = appController.userViewModel?.user?.name ?? ""
            if (appController.userViewModel?.user?.birthmonth != nil) {
                addBirthday = true
            }
            birthmonth = appController.userViewModel?.user?.birthmonth ?? "January"
            birthday = appController.userViewModel?.user?.birthday ?? 1
            wishlist = appController.userViewModel?.user?.wishlist ?? []
            about = appController.userViewModel?.user?.about ?? ""
        }
    }
}

#Preview {
    Text("Expect no data to load in this preview")
        .font(.headline)
        .foregroundStyle(.red)
    EditProfileView().environmentObject(AppController()).environmentObject(GroupsViewModel())
}
