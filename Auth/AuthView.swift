//
//  AuthView.swift
//  giftApp
//
//  Created by user264039 on 10/11/24.
//

import SwiftUI


struct AuthView: View {
    
    
    let paddingAmount: CGFloat = 20
    
    @State private var signingUp = false
    @State private var showProfile = false
    
    var body: some View {
        VStack {
            
                if signingUp {
                    SignUpView(signingUp: $signingUp)
                } else {
                    LogInView(signingUp: $signingUp)
                }
            
                ProfileView()
                Text("Hello")
            
          
        }
    }
    
}

#Preview {
    AuthView()
}
