//
//  TextEntry.swift
//  giftApp
//
//  Created by jmathies on 11/7/24.
//

import SwiftUI

struct StyledTextField: View {
    @State var title: String = ""
    @State var text: String = ""
    @Binding var entry: String
    // doesn't limit character count or display limit if < 0
    @State var characterLimit: Int = 0
    @State var hideLimit: Bool = false
    @State var autoCapitalization: UITextAutocapitalizationType = UITextAutocapitalizationType.none
    
    var body: some View {
        VStack(spacing: 10) {
            if (title.count > 0) {
                HStack {
                        Text(title)
                            .font(.system(size: 20))
                Spacer()
                }
            }
            HStack {
                TextField(text, text: $entry)
                    .font(.system(size: 20))
                if (characterLimit > 0 && !hideLimit) {
                    Text("\(characterLimit - entry.count)")
                        .foregroundStyle(entry.count != characterLimit ? Color.gray : Color.red)
                        .padding([.trailing], 5)
                }
            }
            .padding(6)
            .foregroundStyle(.black)
            .autocorrectionDisabled()
            .autocapitalization(autoCapitalization)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.gray)
                    .opacity(0.2)
            ).frame(height: 30)
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
