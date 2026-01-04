//
//  SceneDelegate.swift
//  Donation
//
//  Created by Claude
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Create tab bar controller
        let tabBarController = UITabBarController()
        
        // Setup Manage Users Tab
        let manageUsersVC = ManageUsersViewController()
        let manageUsersNav = UINavigationController(rootViewController: manageUsersVC)
        manageUsersNav.tabBarItem = UITabBarItem(
            title: "Users",
            image: UIImage(systemName: "person.3.fill"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )
        
        // Setup Reports Tab
        let reportsVC = ReportsListViewController()
        let reportsNav = UINavigationController(rootViewController: reportsVC)
        reportsNav.tabBarItem = UITabBarItem(
            title: "Reports",
            image: UIImage(systemName: "exclamationmark.triangle.fill"),
            selectedImage: UIImage(systemName: "exclamationmark.triangle.fill")
        )
        
        // Configure tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBarController.viewControllers = [manageUsersNav, reportsNav]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
