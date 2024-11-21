//
//  StyledTextEditor.swift
//  giftApp
//
//  Created by jmathies on 11/14/24.
//

import SwiftUI

struct StyledTextEditor: View {
    @State var title: String = ""
    @State var text: String = "Enter text here"
    @Binding var entry: String
    // doesn't limit character count or display limit if < 0
    @State var characterLimit: Int = 0
    @State var hideLimit: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                if (title.count > 0) {
                    Text(title)
                        .font(.system(size: 20))
                }
                Spacer()
                // Displays character limit
                if (characterLimit > 0 && !hideLimit) {
                    Text("\(characterLimit - entry.count)")
                        .foregroundStyle(entry.count != characterLimit ? Color.gray : Color.red)
                        .padding([.trailing], 5)
                }
            }
            ZStack {
                TextEditor(text: $entry)
                    .scrollContentBackground(.hidden)
                if (entry.count == 0) {
                    VStack {
                        HStack {
                                Text(text)
                                    .foregroundStyle(.gray)
                                    .padding([.top], 7)
                                    .padding([.leading], 4)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }.padding(6)
            .font(.system(size: 20))
            .foregroundStyle(.black)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.gray)
                    .opacity(0.2)
            ).frame(height: 150)
        }
        .padding([.top, .bottom], 6)
        .onChange(of: entry) {
            if (characterLimit > 0 && entry.count > characterLimit) {
                entry = String(
                    entry[...entry.index(entry.startIndex, offsetBy: characterLimit - 1)]
                    )
            }
        }
    }
}
