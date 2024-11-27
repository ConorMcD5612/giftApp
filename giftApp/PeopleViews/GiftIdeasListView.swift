//
//  GiftIdeasView.swift
//  giftApp
//
//  Created by jmathies on 11/22/24.
//

import SwiftUI

struct GiftIdeasListView: View {
    @EnvironmentObject var settings: RecipientSettings
    
    @Binding var recipient: Recipient
    @State var searchEntry: String = ""
    @State var createGiftIdea: Bool = false
    @State var selectedIdea: String = ""
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Gift Ideas")
                    Spacer()
                    Button("+") {
                        settings.path.append(.addGiftIdea)
                    }
                }.font(.largeTitle)
                HStack {
                    Text("For \(recipient.name)")
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }.padding([.leading, .trailing])
        
            SearchField(searchEntry: $searchEntry)
                .padding([.leading, .trailing])
            
            ScrollView(showsIndicators: false) {
                if (recipient.giftIdeas.count > 0) {
                    VStack {
                        ForEach(recipient.giftIdeas, id: \.self.id) {idea in
                            if (searchEntry.count != 0) {
                                if (idea.name.lowercased().contains(searchEntry)) {
                                    TextButton(title: idea.name, trailingTitle: idea.creationDate.formatted(date: .abbreviated, time: .omitted), text: idea.description) {
                                        settings.selectedGiftIdea = idea
                                        settings.path.append(.viewGiftIdea)
                                    }
                                }
                            } else {
                                TextButton(title: idea.name, trailingTitle: idea.creationDate.formatted(date: .abbreviated, time: .omitted), text: idea.description) {
                                    settings.selectedGiftIdea = idea
                                    settings.path.append(.viewGiftIdea)
                                }
                            }
                        }
                    }
                } else {
                    Text("You haven't created any gift ideas yet!")
                        .font(.system(size: 20))
                }
            }.scrollBounceBehavior(.basedOnSize)
            .padding([.top, .bottom])
            Spacer()
        }
        .toolbar() {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit Recipient") {
                    settings.path.append(.modifyRecipient)
                }
            }
        }
    }
}
