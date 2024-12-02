//
//  CommentDisplay.swift
//  giftApp
//
//  Created by jmathies on 12/2/24.
//

import SwiftUI

struct CommentDisplay: View {
    @State var name: String
    @State var date: Date
    @State var text: String
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(name)
                Spacer()
                if date.formatted(date: .numeric, time: .omitted) == Date.now.formatted(date: .numeric, time: .omitted) {
                    Text(date, format: .dateTime.hour().minute())
                        .foregroundStyle(.gray)
                } else {
                    Text(date, format: .dateTime.month().day().year())
                }
            }.font(.system(size: 20))
            
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                    .padding(5)
                Spacer()
            }.overlay(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundStyle(.gray)
                    .opacity(0.1)
            )
        }
    }
}

#Preview {
    CommentDisplay(name: "Dave", date: Date.now, text: "Oh yea! That would be awesome! Although, I think it would be better to wait a bit longer before we commit to that idea.")
}
