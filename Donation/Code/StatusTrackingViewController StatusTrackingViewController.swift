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

    // MARK: - Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Circles
    @IBOutlet weak var pendingCircle: UIView!
    @IBOutlet weak var acceptedCircle: UIView!
    @IBOutlet weak var collectedCircle: UIView!
    @IBOutlet weak var completedCircle: UIView!

    // MARK: - Buttons
    @IBOutlet weak var primaryButton: UIButton!     // Confirm / Collection Completed
    @IBOutlet weak var feedbackButton: UIButton!    // Send Feedback
    @IBOutlet weak var doneButton: UIButton!        // Done

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircles()
        setupButtons()
        updateUI()
    }

    // MARK: - Setup
    private func setupCircles() {
        let circles = [pendingCircle, acceptedCircle, collectedCircle, completedCircle]
        circles.forEach {
            $0?.layer.cornerRadius = ($0?.frame.height ?? 0) / 2
            $0?.clipsToBounds = true
        }
    }

    private func setupButtons() {
        feedbackButton.isHidden = true
        doneButton.isHidden = true
    }

    private func resetCircles() {
        let lightGray = UIColor.systemGray4
        pendingCircle.backgroundColor = lightGray
        acceptedCircle.backgroundColor = lightGray
        collectedCircle.backgroundColor = lightGray
        completedCircle.backgroundColor = lightGray
    }

    // MARK: - UI Update
    func updateUI() {
        guard let donation = donation else { return }

        titleLabel.text = donation.title
        resetCircles()

        // Default visibility
        primaryButton.isHidden = false
        feedbackButton.isHidden = true
        doneButton.isHidden = true

        switch donation.pickupStatus {

        case .accepted:
            acceptedCircle.backgroundColor = .systemBlue
            statusLabel.text = "Donation Accepted"
            dateLabel.text = "Waiting for pickup"
            primaryButton.setTitle("Confirm Pickup", for: .normal)

        case .collected:
            acceptedCircle.backgroundColor = .systemBlue
            collectedCircle.backgroundColor = .systemBlue
            statusLabel.text = "Donation Collected"
            dateLabel.text = "In progress"
            primaryButton.setTitle("Collection Completed", for: .normal)

        case .completed:
            acceptedCircle.backgroundColor = .systemBlue
            collectedCircle.backgroundColor = .systemBlue
            completedCircle.backgroundColor = .systemBlue
            statusLabel.text = "Donation Completed"
            dateLabel.text = "Thank you!"

            primaryButton.isHidden = true
            feedbackButton.isHidden = false
            doneButton.isHidden = false

        default:
            break
        }
    }

    // MARK: - Actions
    @IBAction func primaryButtonTapped(_ sender: UIButton) {
        switch donation?.pickupStatus {
        case .accepted:
            donation?.pickupStatus = .collected
        case .collected:
            donation?.pickupStatus = .completed
        default:
            break
        }
        updateUI()
    }

    @IBAction func feedbackTapped(_ sender: UIButton) {
        print("Send Feedback tapped")
        // Navigate to feedback screen later
    }

    @IBAction func doneTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
