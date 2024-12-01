//
//  CreateGroupView.swift
//  giftApp
//
//  Created by jmathies on 11/30/24.
//

import SwiftUI

struct CreateGroupView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    
    // Used to pop view from NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = ""
    @State var memberEmail: String = ""
    @State var members: [String : String] = [:]
    
    @State var checkingUser: Bool = false
    
    @State var userNotFound: Bool = false
    @State var userAlreadyAdded: Bool = false
    
    @State var confirmation: Bool = false
    
    var MAX_NAME_LENGTH: Int = 32
    
    func addMember(email: String) {
        checkingUser = true
        userNotFound = false
        userAlreadyAdded = false
        
        if (members[email] != nil || email == appController.userViewModel?.user?.email ?? "") {
            userAlreadyAdded = true
        } else {
            Task {
                do {
                    let res = try await settings.getDocumentID(for: memberEmail)
                    if (res != nil) {
                        members[email] = res
                    } else {
                        userNotFound = true
                    }
                } catch {
                    print("error finding doc for \(email)")
                }
            }
        }
        
        checkingUser = false
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack(spacing: 0) {
                    StyledTextField(title: "Group Name", text: "Enter name here", entry: $name, characterLimit: MAX_NAME_LENGTH, hideLimit: false, autoCapitalization: UITextAutocapitalizationType.words)
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
                        Text("Members")
                            .font(.system(size: 20))
                        Spacer()
                    }
                    if (members.count != 0) {
                        ForEach(Array(members.keys), id: \.self) {key in
                            HStack {
                                Text("- \(key)")
                                Spacer()
                            }
                        }
                        .font(.system(size: 20))
                    }
                    HStack {
                        StyledTextField(text: "Enter email here", entry: $memberEmail)
                            .frame(width: 250)
                        Button("Add") {
                            addMember(email: memberEmail)
                        }.disabled(checkingUser)
                        Button("Remove", role: .destructive) {
                            members[memberEmail] = nil
                        }
                        Spacer()
                    }
                    HStack {
                        if userNotFound {
                            Text("No user was found with that email")
                                .foregroundStyle(.red)
                        } else if userAlreadyAdded {
                            Text("Member already added")
                                .foregroundStyle(.red)
                        }
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        .padding([.leading, .trailing])
        .scrollBounceBehavior(.basedOnSize)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Creating New Group").font(.headline)
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (name.count != 0 || members.count != 0) {
                        confirmation = true
                    } else {
                        dismiss()
                    }
                }.confirmationDialog("Are you sure you want to cancel creating this new group?", isPresented: $confirmation, titleVisibility: .visible) {
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
                Button("Create") {
                    let creatorID: String = appController.userViewModel?.user?.id! ?? ""
                    var members: [String] = Array(members.values)
                    members.append(creatorID)
                    
                    if creatorID == "" {
                        print("creatorID DNE")
                        dismiss()
                    } else {
                        settings.createGroup(group: Group(name: name, members: members))
                        dismiss()
                    }
                }.disabled(name.count == 0)
            }
        }
    }
}

#Preview {
    CreateGroupView().environmentObject(AppController()).environmentObject(GroupsViewModel())
}
