import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("🟢 AppDelegate: App launched")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Start with the chats list
        let chatsListVC = ChatsListViewController()
        let navController = UINavigationController(rootViewController: chatsListVC)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        print("✅ Chats list loaded")
        
        return true
    }
}
