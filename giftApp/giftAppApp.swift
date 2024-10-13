import SwiftUI
import FirebaseCore


@main
struct GiftApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var appController = AppController()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                //ContentView()
                AuthView()
                //can use this for 17, need to use env obj for 16
                    .environmentObject(appController)
            }
        }			
    }
}
