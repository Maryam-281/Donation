//
//  PickupScheduledViewController.swift
//  Donation
//
//  Created by BP-36-201-02 on 30/12/2025.
//

import UIKit

class PickupScheduledViewController: UIViewController {

    // MARK: - Data
    var donation: Donations?
    var note: String?

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UITextView!

    @IBOutlet weak var donationTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureSummary()
    }

    private func setupUI() {
        notesTextView.isEditable = false
        notesTextView.isScrollEnabled = false
        notesTextView.layer.cornerRadius = 12
        notesTextView.backgroundColor = .systemGray6
    }

    private func configureSummary() {
        guard let donation else { return }

        titleLabel.text = "Pickup Scheduled"
        subtitleLabel.text = """
        Your pickup has been successfully scheduled.
        The donor has been notified.
        """

        donationTitleLabel.text = donation.title
        locationLabel.text = "📍 \(donation.location)"

        if let date = donation.pickupDate {
            let formatter = DateFormatter()

            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            dateLabel.text = "Date: \(formatter.string(from: date))"

            formatter.dateStyle = .none
            formatter.timeStyle = .short
            timeLabel.text = "Time: \(formatter.string(from: date))"
        }

        notesTextView.text = note?.isEmpty == false ? note : "No notes provided."
    }

    @IBAction func viewStatusTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Discovery", bundle: nil)

        guard let statusVC = storyboard.instantiateViewController(
            withIdentifier: "toDonationStatus"
        ) as? StatusTrackingViewController else { return }

        statusVC.donation = donation
        navigationController?.pushViewController(statusVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatusNav",
           let nav = segue.destination as? UINavigationController,
           let statusVC = nav.viewControllers.first as? StatusTrackingViewController {

            statusVC.donation = donation
        }
    }

}
