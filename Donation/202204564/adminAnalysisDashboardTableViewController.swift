//
//  adminAnalysisDashboardTableViewController.swift
//  Donation
//
//  Created by macOS on 22/12/2025.
//

import Foundation
import UIKit





class adminAnalysisDashboardTableViewController : UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mySegmentedController.selectedSegmentIndex = 0
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            navigateToViewController(identifier: "Home")
        case 1:
            navigateToViewController(identifier: "DonationsAnalysis")
        case 2:
            navigateToViewController(identifier: "FeedbackAnalysis")
        default:
            break
        }
    }
    
    func navigateToViewController(identifier: String) {
        let storyboard = UIStoryboard(name: "Analytic&Feedback", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? UITableViewController {
            // Present modally
            self.present(vc, animated: true, completion: nil)
            
            // OR push to navigation stack (if inside UINavigationController)
             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
