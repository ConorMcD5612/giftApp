//
//  CreateGiftBtn.swift
//  giftApp
//
//  Created by user264039 on 11/19/24.
//

import SwiftUI

struct CreateGiftBtn: View {
    @Binding var creatingGift: Bool
    func submitGiftForm() {
        creatingGift.toggle()
    }
    
    var body: some View {
            Button(action: submitGiftForm) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.white)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .frame(width: .infinity, height: 50)
                    Image(systemName: "plus.circle")
                        .font(.system(size: 30))
                }
                .padding(.horizontal, 5)
            }
    }
}

#Preview {
    CreateGiftBtn(creatingGift: .constant(true))
}
