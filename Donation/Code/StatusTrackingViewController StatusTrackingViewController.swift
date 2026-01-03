//
//  StatusTrackingViewController StatusTrackingViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit

class StatusTrackingViewController: UIViewController {

    // MARK: - Data
    var donation: Donations?

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var pendingCircle: UIImageView!
    @IBOutlet weak var acceptedCircle: UIImageView!
    @IBOutlet weak var collectedCircle: UIImageView!
    @IBOutlet weak var completedCircle: UIImageView!

    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!

    private let activeColor = UIColor(named: "#89AAC5")
    private let inactiveColor = UIColor(named: "#C1D6E6")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        updateUI()
    }

    private func setupButtons() {
        feedbackButton.isHidden = true
        doneButton.isHidden = true
    }

    private func resetCircles() {
        [pendingCircle, acceptedCircle, collectedCircle, completedCircle]
            .forEach { $0?.tintColor = inactiveColor }
    }

    private func updateUI() {
        guard let donation else { return }
        
        titleLabel.text = donation.title
        resetCircles()
        
        primaryButton.isHidden = false
        feedbackButton.isHidden = true
        doneButton.isHidden = true
        
        switch donation.pickupStatus {
            
        case .available:
            statusLabel.text = "Available"
            dateLabel.text = "Not scheduled yet"
            primaryButton.isHidden = true
            
        case .scheduled:
            pendingCircle.tintColor = activeColor
            statusLabel.text = "Pickup Scheduled"
            dateLabel.text = "Waiting for donor confirmation"
            primaryButton.setTitle("Mark as Accepted", for: .normal)
            
        case .accepted:
            pendingCircle.tintColor = activeColor
            acceptedCircle.tintColor = activeColor
            statusLabel.text = "Donation Accepted"
            dateLabel.text = "Waiting for pickup"
            primaryButton.setTitle("Confirm Pickup", for: .normal)
            
        case .collected:
            pendingCircle.tintColor = activeColor
            acceptedCircle.tintColor = activeColor
            collectedCircle.tintColor = activeColor
            statusLabel.text = "Donation Collected"
            dateLabel.text = "In progress"
            primaryButton.setTitle("Collection Completed", for: .normal)
            
        case .completed:
            pendingCircle.tintColor = activeColor
            acceptedCircle.tintColor = activeColor
            collectedCircle.tintColor = activeColor
            completedCircle.tintColor = activeColor
            statusLabel.text = "Donation Completed"
            dateLabel.text = "Thank you!"
            
            primaryButton.isHidden = true
            feedbackButton.isHidden = false
            doneButton.isHidden = false
        }
    }


    @IBAction func primaryButtonTapped(_ sender: UIButton) {
        switch donation?.pickupStatus {
        case .scheduled:
            donation?.pickupStatus = .accepted
        case .accepted:
            donation?.pickupStatus = .collected
        case .collected:
            donation?.pickupStatus = .completed
        default:
            break
        }
        updateUI()
    }

    @IBAction func doneTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toPickupCompleted", sender: nil)
    }
}
