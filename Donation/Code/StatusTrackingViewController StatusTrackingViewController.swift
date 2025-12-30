//
//  StatusTrackingViewController StatusTrackingViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit

class StatusTrackingViewController: UIViewController {

    var donation: Donations?

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func confirmPickupTapped(_ sender: UIButton) {
        donation?.pickupStatus = .pickedUp
        updateUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        guard let donation = donation else { return }

        switch donation.pickupStatus {
        case .accepted:
            statusLabel.text = "Donation Accepted"
            dateLabel.text = "Waiting for pickup scheduling"

        case .scheduled:
            statusLabel.text = "Pickup Scheduled"
            if let date = donation.pickupDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                dateLabel.text = formatter.string(from: date)
            }

        case .pickedUp:
            statusLabel.text = "Donation Picked Up"
            dateLabel.text = "Completed"

        default:
            statusLabel.text = "Available"
            dateLabel.text = ""
        }
    }
}

