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
            Text(appController.userViewModel?.user?.firstName ?? "")
        }
    }		
        
}
   		

#Preview {
    ProfileMainView()
}
	
