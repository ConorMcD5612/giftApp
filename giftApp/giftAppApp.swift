import SwiftUI
import FirebaseCore


@main
struct GiftApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var appController: AppController = AppController();
        
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .environmentObject(appController)
            }
        }			
    }
}

