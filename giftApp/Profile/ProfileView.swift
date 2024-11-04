//
//  SwiftUIView.swift
//  giftApp
//
//  Created by user264039 on 10/24/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var userViewModel: UserViewModel = UserViewModel();
    
    var body: some View {
        VStack {
            Text(userViewModel.user?.firstName ?? "")
            
        }
    }
        
}
   

#Preview {
    ProfileView()
}
	
