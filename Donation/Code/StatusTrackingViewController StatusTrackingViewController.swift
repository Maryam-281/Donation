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

    // MARK: - Colors
    private let activeColor = UIColor(hex: "#89AAC5")
    private let inactiveColor = UIColor(hex: "#C1D6E6")

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        lockButtonFonts()
        styleFeedbackButton()
        configureButtons()
        updateUI()
    }

    // MARK: - Font Lock (prevents storyboard font reset)
    private func lockButtonFonts() {
        let buttons = [primaryButton, feedbackButton, doneButton]

        buttons.forEach { button in
            guard let button else { return }
            if let font = button.titleLabel?.font {
                button.titleLabel?.font = font
            }
        }
    }

    // MARK: - Button Styling
    private func styleFeedbackButton() {
        feedbackButton.backgroundColor = .systemGray5
        feedbackButton.setTitleColor(activeColor, for: .normal)
    }

    // MARK: - Button Setup
    private func configureButtons() {
        primaryButton.isHidden = true
        feedbackButton.isHidden = true
        doneButton.isHidden = true

        primaryButton.isEnabled = true
        feedbackButton.isEnabled = true
        doneButton.isEnabled = true

        primaryButton.alpha = 1
        feedbackButton.alpha = 1
        doneButton.alpha = 1
    }

    private func resetButtons() {
        primaryButton.isHidden = true
        feedbackButton.isHidden = true
        doneButton.isHidden = true

        primaryButton.isEnabled = true
        feedbackButton.isEnabled = true
        doneButton.isEnabled = true

        primaryButton.alpha = 1
        feedbackButton.alpha = 1
        doneButton.alpha = 1
    }

    // MARK: - Circles
    private func resetCircles() {
        [pendingCircle, acceptedCircle, collectedCircle, completedCircle]
            .forEach { $0?.tintColor = inactiveColor }
    }

    // MARK: - UI Update (Single Source of Truth)
    private func updateUI() {
        guard let donation else { return }

        titleLabel.text = donation.title

        resetCircles()
        resetButtons()

        switch donation.pickupStatus {

        case .available:
            statusLabel.text = "Available"
            dateLabel.text = "Not scheduled yet"

        case .scheduled:
            pendingCircle.tintColor = activeColor
            statusLabel.text = "Pickup Scheduled"
            dateLabel.text = "Waiting for donor confirmation"

            primaryButton.isHidden = false
            primaryButton.setTitle("Mark as Accepted", for: .normal)

        case .accepted:
            pendingCircle.tintColor = activeColor
            acceptedCircle.tintColor = activeColor
            statusLabel.text = "Donation Accepted"
            dateLabel.text = "Waiting for pickup"

            primaryButton.isHidden = false
            primaryButton.setTitle("Confirm Pickup", for: .normal)

        case .collected:
            pendingCircle.tintColor = activeColor
            acceptedCircle.tintColor = activeColor
            collectedCircle.tintColor = activeColor
            statusLabel.text = "Donation Collected"
            dateLabel.text = "In progress"

            primaryButton.isHidden = false
            primaryButton.setTitle("Collection Completed", for: .normal)

        case .completed:
            pendingCircle.tintColor = activeColor
            acceptedCircle.tintColor = activeColor
            collectedCircle.tintColor = activeColor
            completedCircle.tintColor = activeColor
            statusLabel.text = "Donation Completed"
            dateLabel.text = "Thank you!"

            feedbackButton.isHidden = false
            doneButton.isHidden = false
        }
    }

    // MARK: - Actions
    @IBAction func primaryButtonTapped(_ sender: UIButton) {
        guard let donation else { return }

        switch donation.pickupStatus {
        case .scheduled:
            donation.pickupStatus = .accepted
        case .accepted:
            donation.pickupStatus = .collected
        case .collected:
            donation.pickupStatus = .completed
        default:
            break
        }

        updateUI()
    }

    @IBAction func doneTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toPickupCompleted", sender: nil)
    }

    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
