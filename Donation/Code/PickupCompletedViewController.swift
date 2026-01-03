//
//  PickupCompletedViewController.swift
//  Donation
//
//  Created by BP-19-130-14 on 03/01/2026.
//

import Foundation
import UIKit

class PickupCompletedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

 
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            guard
                let tabBar = UIApplication.shared
                    .connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap({ $0.windows })
                    .first(where: { $0.isKeyWindow })?
                    .rootViewController as? UITabBarController
            else { return }

            // Select Home tab (usually index 0)
            tabBar.selectedIndex = 0

            // Pop navigation stack inside that tab
            if let nav = tabBar.viewControllers?[0] as? UINavigationController {
                nav.popToRootViewController(animated: true)
            }
        }
    }
}
