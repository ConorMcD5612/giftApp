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
        case profileView, editProfileView, createGroupView
    }
    
    @Published var groups: [Group]
    @Published var visibleUsers: [String : User]
    @Published var path: [Views]
    @Published var selectedGroup: Group?
    
    init() {
        self.groups = []
        self.visibleUsers = [:]
        self.path = []
        self.selectedGroup = nil
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
    
    func createGroup(group: Group) {
        let db = Firestore.firestore()
        do {
            let groupRef = try db.collection("groups").addDocument(from: group)
            for memberID in group.members {
                let userRef = db.collection("users").document(memberID)
                userRef.updateData([
                    "groups": FieldValue.arrayUnion([groupRef])
                ])
            }
        } catch {
            print("failed to create group document")
        }
    }
    
    func getGroupData(user: User) async throws {
        let db = Firestore.firestore()
        
        for groupRef in user.groups {
            do {
                let document = try await groupRef.getDocument()
                if let groupData = try? document.data(as: Group.self) {
                    groups.append(groupData)
                } else {
                    print("document for group does not exist / does not match :'(")
                }
            } catch {
                print("fetch group data error")
            }
        }
                
        for group in groups {
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
        print("Count: \(visibleUsers.count)")
    }
}
