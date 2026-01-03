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

    // MARK: - Circles (UIImageView)
    @IBOutlet weak var pendingCircle: UIImageView!
    @IBOutlet weak var acceptedCircle: UIImageView!
    @IBOutlet weak var collectedCircle: UIImageView!
    @IBOutlet weak var completedCircle: UIImageView!

    // MARK: - Buttons
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!

    // MARK: - Colors
    private let activeColor = UIColor(hex: "#89AAC5")
    private let inactiveColor = UIColor(hex: "#C1D6E6")

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        updateUI()
    }

    // MARK: - Setup
    private func setupButtons() {
        feedbackButton.isHidden = true
        doneButton.isHidden = true
    }

    private func resetCircles() {
        pendingCircle.tintColor = inactiveColor
        acceptedCircle.tintColor = inactiveColor
        collectedCircle.tintColor = inactiveColor
        completedCircle.tintColor = inactiveColor
    }

    // MARK: - UI Update
    private func updateUI() {
        guard let donation = donation else { return }

        titleLabel.text = donation.title
        resetCircles()

        primaryButton.isHidden = false
        feedbackButton.isHidden = true
        doneButton.isHidden = true

        switch donation.pickupStatus {

        case .accepted:
            acceptedCircle.tintColor = activeColor
            statusLabel.text = "Donation Accepted"
            dateLabel.text = "Waiting for pickup"
            primaryButton.setTitle("Confirm Pickup", for: .normal)

        case .collected:
            acceptedCircle.tintColor = activeColor
            collectedCircle.tintColor = activeColor
            statusLabel.text = "Donation Collected"
            dateLabel.text = "In progress"
            primaryButton.setTitle("Collection Completed", for: .normal)

        case .completed:
            acceptedCircle.tintColor = activeColor
            collectedCircle.tintColor = activeColor
            completedCircle.tintColor = activeColor
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
        // navigate to feedback screen later
    }

    @IBAction func doneTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toPickupCompleted", sender: nil)
    }

}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}


