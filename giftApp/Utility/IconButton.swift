//
//  NewIconButton.swift
//  giftApp
//
//  Created by jmathies on 10/18/24.
//

import SwiftUI

struct IconButton: View {
    var text: String = ""
    var subtext: String = ""
    var iconName: String = ""
    var iconColor: Color = .teal
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            HStack {
                if iconName != "" {
                    Image(iconName)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 75, height: 75)
                        .padding([.leading])
                } else {
                    ZStack {
                        Circle()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(iconColor)
                        Text(text.prefix(1).uppercased())
                            .font(.title)
                            .foregroundStyle(.white)
                            .bold()
                    }.padding([.leading])
                }
                VStack {
                    HStack {
                        Text(text)
                            .font(.title)
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    if subtext != "" {
                        HStack {
                            Text(subtext)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }
                }
                Spacer()
            }.frame(height: 100)
        }.overlay(
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(.gray)
                .opacity(0.1)
        )
    }
}

#Preview {
    IconButton(text: "Text", subtext: "Subtext", iconName: "TestIcon")
}
