//
//  CreateGift.swift
//  giftApp
//
//  Created by user264039 on 11/14/24.
//

import SwiftUI

struct CreateGift: View {
    @State var creatingGift = false;
    var body: some View {
        
        if(creatingGift) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(.white)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .frame(width: .infinity, height: 50)
                
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
            }
            .padding()
        } else {
            GiftCreateForm(creatingGift: $creatingGift)
        }
        
        
        
        
    }
}

#Preview {
    CreateGift()
}
