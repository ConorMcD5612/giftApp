//
//  GroupGiftIdeaView.swift
//  giftApp
//
//  Created by jmathies on 12/2/24.
//

import SwiftUI

struct GroupGiftIdeaView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    
    @State var comment: String = ""
    @State var postingComment: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack {
                    Text("Idea: \(settings.getSelectedGiftIdea().name)")
                        .font(.largeTitle)
                    Spacer()
                }
                HStack {
                    Text("Proposed by \(settings.visibleUsers[settings.getSelectedGiftIdea().creator]?.name ?? "Unknown User")")
                        .font(.system(size: 20))
                    Spacer()
                }
                
                Divider()
                HStack {
                    Text("Added \(settings.getSelectedGiftIdea().creationDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 20))
                    Spacer()
                }
                
                if (settings.getSelectedGiftIdea().giftingDate != nil) {
                    HStack {
                        Text("To be gifted on \(settings.getSelectedGiftIdea().giftingDate!.formatted(date: .abbreviated, time: .omitted))")
                            .font(.system(size: 20))
                        Spacer()
                    }
                }
                
                if (settings.getSelectedGiftIdea().link.count > 0) {
                    HStack {
                        Link("Link to Gift", destination: URL(string: settings.getSelectedGiftIdea().link)!)
                            .font(.system(size: 20))
                        Spacer()
                    }
                }
                
                if (settings.getSelectedGiftIdea().description.count > 0) {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Description")
                                .font(.title3)
                            Spacer()
                        }
                        Divider()
                    }.padding([.top])
                }
                
                HStack {
                    Text(settings.getSelectedGiftIdea().description)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    Text("Comments")
                        .font(.system(size: 20))
                    Spacer()
                }
                
                HStack {
                    StyledTextField(title: "", text: "Enter your comment here", entry: $comment, characterLimit: 200)
                    Button("Post") {
                        postingComment = true
                        let commentText = comment
                        Task {
                            try await settings.addComment(groupID: settings.selectedGroup, memberID: settings.selectedUser, giftIdeaID: settings.selectedGiftIdea, comment: Comment(posterID: (appController.userViewModel?.user?.id)!, timestamp: Date.now, text: commentText))
                            try await settings.getGroupData(user: (appController.userViewModel?.user)!)
                            postingComment = false
                        }
                        comment = ""
                    }.disabled(postingComment)
                    Spacer()
                }
                
                ForEach(settings.getSelectedGiftIdea().comments, id: \.self.id) { comment in
                    CommentDisplay(name: settings.visibleUsers[comment.posterID]?.name ?? "Unknown User", date: comment.timestamp, text: comment.text)
                }

                Spacer()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .padding([.leading, .trailing])
        .toolbar() {
            if settings.getSelectedGiftIdea().creator == appController.userViewModel?.user?.id ?? "" {
                ToolbarItem(placement: .confirmationAction) {
                    Button("", systemImage: "square.and.pencil") {
                        settings.path.append(.editMemberGiftIdeaView)
                    }
                }
            }
        }
    }
}
