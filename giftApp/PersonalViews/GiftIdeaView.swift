//
//  GiftIdeaView.swift
//  giftApp
//
//  Created by jmathies on 11/26/24.
//

import SwiftUI

struct GiftIdeaView: View {
    @EnvironmentObject var settings: PersonalViewModel

    @Binding var giftIdea: RecipientGiftIdea
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Idea: \(giftIdea.name)")
                    .font(.largeTitle)
                Spacer()
            }
            Divider()
            HStack {
                Text("Added \(giftIdea.creationDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(size: 20))
                Spacer()
            }
            
            if (giftIdea.link.count > 0) {
                HStack {
                    Link("Link to Gift", destination: URL(string: giftIdea.link)!)
                        .font(.system(size: 20))
                    Spacer()
                }
            }
            
            if (giftIdea.description.count > 0) {
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
                Text(giftIdea.description)
                    .multilineTextAlignment(.leading)
                Spacer()
            }

            Spacer()
        }.padding([.leading, .trailing])
        .toolbar() {
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "square.and.pencil") {
                    settings.path.append(.modifyGiftIdea)
                }
            }
        }
    }
}
