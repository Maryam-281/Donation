//
//  DonationDetailsViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit

class DonationDetailsViewController: UIViewController {

    // MARK: - Data
    var donation: Donations?

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productionDateLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var donorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationLabel: UITextView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print("🟢 viewDidLoad called")

        print("titleLabel:", titleLabel as Any)
        print("descriptionTextView:", descriptionTextView as Any)
        print("categoryLabel:", categoryLabel as Any)
        print("productionDateLabel:", productionDateLabel as Any)
        print("expirationDateLabel:", expirationDateLabel as Any)
        print("donorLabel:", donorLabel as Any)
        print("statusLabel:", statusLabel as Any)
        print("locationLabel:", locationLabel as Any)

        configureTextView()
        updateUI()
    }


    // MARK: - UI Setup
    private func configureTextView() {
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = true
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
    }

    private func updateUI() {
        guard let donation = donation else { return }

        titleLabel.text = donation.title
        descriptionTextView.text = donation.donationDescription
        categoryLabel.text = donation.category

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        productionDateLabel.text = formatter.string(from: donation.productionDate)
        expirationDateLabel.text = formatter.string(from: donation.expirationDate)

        // These appear LAST on screen (as per your design)
        donorLabel.text = "Donor: \(donation.donorName)"
        locationLabel.text = "Location: \(donation.location)"
    }

    // MARK: - Actions
    @IBAction func acceptTapped(_ sender: UIButton) {
        donation?.pickupStatus = .accepted
        performSegue(withIdentifier: "toSchedulePickup", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSchedulePickup",
           let destination = segue.destination as? SchedulePickupViewController {
            destination.donation = donation
        }
    }
}








