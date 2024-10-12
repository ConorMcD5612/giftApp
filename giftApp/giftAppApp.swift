import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

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
