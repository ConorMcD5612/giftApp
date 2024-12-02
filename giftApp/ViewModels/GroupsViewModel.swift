//
//  GroupsSettings.swift
//  giftApp
//
//  Created by jmathies on 11/27/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class GroupsViewModel: ObservableObject {
    enum Views {
        case profileView, editProfileView, createGroupView, groupView, editGroupView, memberGiftIdeasView, addMemberGiftIdeaView
    }
    
    @Published var groups: [String : Group]
    @Published var visibleUsers: [String : User]
    @Published var path: [Views]
    @Published var selectedGroup: Group
    @Published var selectedUser: User?
    
    init() {
        self.groups = [:]
        self.visibleUsers = [:]
        self.path = []
        // Placeholder; never get utilized; to avoid using optionals
        self.selectedGroup = Group(name: "", members: [])
        self.selectedUser = nil
    }
    
    func getDocumentID(for email: String) async throws -> String? {
        let db = Firestore.firestore()
        
        let users = db.collection("users")
        let query = users.whereField("email", in: [email])
                
        do {
            let documents = try await query.getDocuments()
            if !documents.documents.isEmpty {
                if let userData = try? documents.documents.first!.data(as: User.self) {
                    return userData.id
                }
            }
        } catch {
            print("couldn't find user with email \(email)")
        }
        
        return nil
    }
    
    func getEmail(for id: String) async throws -> String? {
        let db = Firestore.firestore()
        let query = db.collection("users").document(id)
        
        do {
            let document = try await query.getDocument()
            if let userData = try? document.data(as: User.self) {
                return userData.email
            }
        } catch {
            print("Error fetching email for \(id)")
        }
        return nil
    }
    
    func getMembers(from group: Group, currentUserID: String) -> String {
        var string: String = ""
                
        for memberID in group.members {
            if string.count != 0 && memberID != currentUserID {
                string += ", "
            }
            
            if memberID != currentUserID {
                string += visibleUsers[memberID]?.name ?? ""
            }
        }
        
        return string
    }
    
    func createGroup(group: Group) {
        let db = Firestore.firestore()
        
        for memberID in group.members {
            group.memberGiftIdeas[memberID] = []
        }
        
        do {
            let groupRef = try db.collection("groups").addDocument(from: group)
            for memberID in group.members {
                let userRef = db.collection("users").document(memberID)
                userRef.updateData([
                    "groups": FieldValue.arrayUnion([groupRef])
                ])
                groupRef.updateData([
                    "memberGiftIdeas.\(memberID)": []
                ])
            }
        } catch {
            print("failed to create group document")
        }
    }
    
    func updateGroup(group: Group) async throws {
        let db = Firestore.firestore()
        do {
            let groupRef = db.collection("groups").document(group.id!)
            let document = try await groupRef.getDocument()
            
            if let origGroupData = try? document.data(as: Group.self) {
                let origMembers = origGroupData.members
                
                for memberID in group.members {
                    // User is being added to group
                    if !origMembers.contains(memberID) {
                        addMember(groupID: group.id!, memberID: memberID)
                        if origGroupData.memberGiftIdeas[memberID] == nil {
                            try await groupRef.updateData([
                                "memberGiftIdeas.\(memberID)": []
                            ])
                        }
                    }
                }
                
                for memberID in origMembers {
                    // User has been removed from group
                    if !group.members.contains(memberID) {
                        removeMember(groupID: group.id!, memberID: memberID)
                    }
                }
            }
            
            try await groupRef.updateData([
                "name": group.name,
            ])
            print("successfully updated group info")
        } catch {
            print("failed to update group document")
        }
    }
    
    func addMember(groupID: String, memberID: String) {
        let db = Firestore.firestore()
        
        let groupRef = db.collection("groups").document(groupID)
        let userRef = db.collection("users").document(memberID)
        
        groupRef.updateData([
            "members": FieldValue.arrayUnion([memberID]),
        ])
        
        userRef.updateData([
            "groups": FieldValue.arrayUnion([groupRef])
        ])
    }
    
    func removeMember(groupID: String, memberID: String) {
        let db = Firestore.firestore()
        
        let groupRef = db.collection("groups").document(groupID)
        let userRef = db.collection("users").document(memberID)
        
        groupRef.updateData([
            "members": FieldValue.arrayRemove([memberID])
        ])
        
        userRef.updateData([
            "groups": FieldValue.arrayRemove([groupRef])
        ])
    }
    
    func addGiftIdea(groupID: String, memberID: String, giftIdea: GroupGiftIdea) {
        let db = Firestore.firestore()
        
        let groupRef = db.collection("groups").document(groupID)
        
        Task {
            do {
                let document = try await groupRef.getDocument()
                if let groupData = try? document.data(as: Group.self) {
                    groupData.memberGiftIdeas[memberID]?.append(giftIdea)
                    try groupRef.setData(from: groupData)
                    print("Successfully saved group gift idea")
                } else {
                    print("document for group does not exist / does not match :'(")
                }
            } catch {
                print("fetch group data error")
            }
        }
    }
    
    func getGroupData(user: User) async throws {
        let db = Firestore.firestore()
        
        for groupRef in user.groups {
            do {
                let document = try await groupRef.getDocument()
                if let groupData = try? document.data(as: Group.self) {
                    groups[groupRef.documentID] = groupData
                } else {
                    print("group document \(groupRef.documentID) does not exist / does not match ")
                }
            } catch {
                print("fetch group data error")
            }
        }
                
        for group in groups.values {
            for memberID in group.members {
                if visibleUsers[memberID] == nil && memberID != user.id {
                    let query = db.collection("users").document(memberID)
                    
                    do {
                        let document = try await query.getDocument()
                        if let userData = try? document.data(as: User.self) {
                            visibleUsers[memberID] = userData
                        } else {
                            print("document for group user \(memberID) does not exist / does not match :'(")
                        }
                    } catch {
                        print("fetch group data error")
                    }
                }
            }
        }
    }
}
