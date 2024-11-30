//
//  RecipientsView.swift
//  giftApp
//
//  Created by jmathies on 10/16/24.
//

import SwiftUI

struct PersonalMainView: View {
    @EnvironmentObject var settings: PersonalViewModel
    @State var searchEntry: String = ""
    
    var body: some View {
        NavigationStack(path: $settings.path) {
            VStack {
                // Recipients title and add recipient button
                HStack {
                    Text("Gift Recipients")
                    Spacer()
                    Button("+") {
                        settings.path.append(.addRecipient)
                    }
                }.font(.largeTitle)
                    .padding([.leading, .trailing])
                
                // Search bar
                SearchField(searchEntry: $searchEntry)
                    .padding([.leading, .trailing])
                
                ScrollView(showsIndicators: false) {
                    if (settings.recipients.count > 0) {
                        VStack {
                            ForEach($settings.recipients, id: \.self.id) {$recipient in
                                if (searchEntry.count != 0) {
                                    if (recipient.name.lowercased().contains(searchEntry.lowercased())) {
                                        IconButton(text: recipient.name) {
                                            settings.selectedRecipient = recipient
                                            settings.path.append(.viewGiftIdeaList)
                                        }
                                    }
                                } else {
                                    IconButton(text: recipient.name) {
                                        settings.selectedRecipient = recipient
                                        settings.path.append(.viewGiftIdeaList)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("You haven't added any recipients yet!")
                            .font(.system(size: 20))
                    }
                }.scrollBounceBehavior(.basedOnSize)
                .padding([.top, .bottom])
            }.navigationDestination(for: PersonalViewModel.Views.self) { view in
                switch view {
                case .addRecipient:
                    AddRecipientView(recipients: $settings.recipients)
                case .viewGiftIdeaList:
                    GiftIdeasListView(recipient: $settings.selectedRecipient)
                case .editRecipient:
                    EditRecipientView(recipient: $settings.selectedRecipient)
                case .addGiftIdea:
                    AddGiftIdeaView(recipient: $settings.selectedRecipient)
                case .viewGiftIdea:
                    GiftIdeaView(giftIdea: $settings.selectedGiftIdea)
                case .editGiftIdea:
                    EditGiftIdeaView(recipient: $settings.selectedRecipient, giftIdea: $settings.selectedGiftIdea)
                }
            }
        }
    }
}

#Preview {
    PersonalMainView().environmentObject(PersonalViewModel())
}
