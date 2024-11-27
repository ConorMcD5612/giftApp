//
//  TextButton.swift
//  giftApp
//
//  Created by jmathies on 11/25/24.
//

import SwiftUI

struct TextButton: View {
    var title: String = ""
    var trailingTitle: String = ""
    var text: String = ""
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            VStack {
                HStack {
                    VStack {
                        HStack {
                            Text(title)
                                .font(.title)
                                .foregroundStyle(.black)
                            Spacer()
                            Text(trailingTitle)
                                .font(.title3)
                                .foregroundStyle(.gray)
                            
                        }
                        HStack {
                            Text(text)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Spacer()
                }
                Spacer()
            }.frame(height: text.count > 0 ? 70 : 50)
                .padding([.leading, .trailing, .top])
        }.overlay(
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(.gray)
                .opacity(0.1)
        )
    }
}

#Preview {
    TextButton(title: "Title That Is Too Long", trailingTitle: "Trailing Title", text: "This is a description that demonstrates the full extent of what this would look like if filled to the brim.")
}
