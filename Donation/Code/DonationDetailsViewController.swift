//
//  DonationDetailsViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit
import Foundation
class DonationDetailsViewController: UIViewController {
    var donation: Donations!
    
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        donation.pickupStatus = .accepted
        performSegue(withIdentifier: "toSchedulePickup", sender: donation)
    }
}

