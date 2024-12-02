//
//  EditGroupView.swift
//  giftApp
//
//  Created by jmathies on 12/1/24.
//

import SwiftUI

struct EditGroupView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    
    // Used to pop view from NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    @State var group: Group = Group(name: "", members: [])
    
    @State var name: String = ""
    @State var memberEmail: String = ""
    @State var members: [String : String] = [:]
    
    @State var checkingUser: Bool = false
    
    @State var userNotFound: Bool = false
    @State var userAlreadyAdded: Bool = false
    @State var removingSelf: Bool = false
    
    @State var loadingMembers: Bool = false
    
    @State var cancelConfirmation: Bool = false
    @State var leaveGroupConfirmation: Bool = false
    
    var MAX_NAME_LENGTH: Int = 32
    
    func addMember(email: String) {
        checkingUser = true
        userNotFound = false
        userAlreadyAdded = false
        removingSelf = false
        
        if (members[email] != nil) {
            userAlreadyAdded = true
        } else if email == appController.userViewModel?.user?.email ?? "" {
            removingSelf = true
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
        VStack {
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
                                            
                        if (loadingMembers) {
                            Text("Loading...")
                                .font(.system(size: 16))
                        } else {
                            ForEach(Array(members.keys).sorted(), id: \.self) {email in
                                HStack {
                                    Text("- \(email) \(email == appController.userViewModel?.user?.email ? "(you)" : "")")
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
                                if (memberEmail == appController.userViewModel?.user?.email) {
                                    removingSelf = true
                                } else {
                                    members[memberEmail] = nil
                                }
                            }
                            Spacer()
                        }
                        HStack {
                            if userNotFound {
                                Text("No user was found with that email")
                            } else if userAlreadyAdded {
                                Text("Member already added")
                            } else if removingSelf {
                                Text("Press 'Leave group' to remove yourself from it")
                            }
                            Spacer()
                        }.foregroundStyle(.red)
                    }
                    Spacer()
                }
            }
            Spacer()
            
            Button("Leave Group", role: .destructive) {
                leaveGroupConfirmation = true
            }.padding([.bottom])
            .confirmationDialog("Are you sure you want to leave this group?", isPresented: $leaveGroupConfirmation, titleVisibility: .visible) {
                Button("Leave Group", role: .destructive) {
                    leaveGroupConfirmation = false
                    let userID = appController.userViewModel?.user?.id
                    if userID != nil {
                        settings.removeMember(groupID: group.id!, memberID: userID!)
                        settings.groups[group.id!] = nil
                        Task {
                            try await appController.userViewModel?.fetchUserData()
                            try await settings.getGroupData(user: (appController.userViewModel?.user)!)
                        }
                        settings.path.removeAll()
                    } else {
                        print("Invalid userID when trying to leave group")
                    }
                }
                Button("Cancel", role: .cancel) {
                    leaveGroupConfirmation = false
                }
            }
        }
        .padding([.leading, .trailing])
        .scrollBounceBehavior(.basedOnSize)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Editing Group").font(.headline)
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (name != group.name || Array(members.values).sorted() != group.members.sorted()) {
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
                    group.name = name
                    group.members = Array(members.values).sorted()
                    Task {
                        try await settings.updateGroup(group: group)
                        try await appController.userViewModel?.fetchUserData()
                        try await settings.getGroupData(user: (appController.userViewModel?.user)!)
                        settings.objectWillChange.send()
                    }
                    dismiss()
                }.disabled(name.count == 0)
            }
        }
        .onAppear() {
            group = settings.getSelectedGroup()
            name = group.name
            loadingMembers = true
            Task {
                for memberID in group.members {
                    let memberEmail: String? = try await settings.getEmail(for: memberID)
                    if memberEmail != nil {
                        members[memberEmail!] = memberID
                    }
                }
                loadingMembers = false
            }
        }
    }
}
