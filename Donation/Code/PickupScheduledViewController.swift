//
//  PickupScheduledViewController.swift
//  Donation
//
//  Created by BP-36-201-02 on 30/12/2025.
//

import UIKit

class PickupScheduledViewController: UIViewController {

    // MARK: - Data (REQUIRED)
    var donation: Donations?

    // MARK: - Outlets (match storyboard)
    @IBOutlet weak var statusLabel: UITextView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var noteTextField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text =
        "Your pickup has been successfully scheduled.\nThe donor has been notified."

        statusImageView.image = UIImage(named: "pickup_success") // your image name
    }

    @IBAction func continueTapped(_ sender: UIButton) {
        // storyboard segue only
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDonationStatus",
           let destination = segue.destination as? StatusTrackingViewController {
            destination.donation = donation
        }
    }
}
