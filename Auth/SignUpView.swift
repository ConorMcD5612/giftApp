//
//  SignUpView.swift
//  giftApp
//
//  Created by user264039 on 10/17/24.
//

import SwiftUI

struct SignUpView: View {
    @Binding var signingUp: Bool
    
    var body: some View {
        VStack(spacing: 100) {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                Text("Make an account for giftApp")
                    .foregroundColor(.gray)
            }
            .padding()
            
            EmailPassView(signingUp: $signingUp)
            
            HStack {
                Text("Already have an account?")
                Button("Sign In") {
                    signingUp.toggle()
                }
            }
            
        }
    }
}

#Preview {
    SignUpView(signingUp: .constant(true))
}
