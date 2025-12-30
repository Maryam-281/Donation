//
//  DonationDetailsViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit

class DonationDetailsViewController: UIViewController {

    var donation: Donations?

    @IBAction func acceptTapped(_ sender: UIButton) {
        donation?.pickupStatus = .accepted
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSchedulePickup",
           let destination = segue.destination as? SchedulePickupViewController {

            destination.donation = donation
        }
    }
}







