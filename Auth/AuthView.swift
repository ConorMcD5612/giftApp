//
//  AuthView.swift
//  giftApp
//
//  Created by user264039 on 10/11/24.
//

import SwiftUI


struct AuthView: View {
    @State private var signingUp = false
    
    var body: some View {
        VStack {
            if signingUp {
                SignUpView(signingUp: $signingUp)
            } else {
                LogInView(signingUp: $signingUp)
            }
        }
    }
}

#Preview {
    AuthView()
}
