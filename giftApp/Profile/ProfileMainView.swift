//
//  SwiftUIView.swift
//  giftApp
//
//  Created by user264039 on 10/24/24.
//

import SwiftUI

struct ProfileMainView: View {
    @EnvironmentObject var appController: AppController
    
    var body: some View {
        VStack {
            Image(systemName: "person")
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.black, lineWidth: 4)
                }
                .shadow(radius: 5)
            Text(appController.userViewModel?.user?.firstName ?? "")
        }
    }		
        
}
   		

#Preview {
    ProfileMainView()
}
	
