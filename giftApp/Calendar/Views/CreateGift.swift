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
            GiftCreateForm(creatingGift: $creatingGift)
        } else {
            CreateGiftBtn(creatingGift: $creatingGift)
        }
    }
}

#Preview {
    CreateGift()
}
