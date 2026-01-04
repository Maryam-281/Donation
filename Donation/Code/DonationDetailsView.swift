//
//  DonationDetailsView.swift
//  Donation
//
//  Created by BP-19-130-14 on 02/01/2026.
//
import UIKit

class DonationDetailsView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productionDateLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var donorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    // MARK: - Configure
    func configure(with donation: Donations) {

        titleLabel.text = donation.title
        descriptionTextView.text = donation.donationDescription
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        categoryLabel.attributedText =
            styledText(label: "Category", value: donation.category)

        productionDateLabel.attributedText =
            styledText(
                label: "Production date",
                value: formatter.string(from: donation.productionDate)
            )

        expirationDateLabel.attributedText =
            styledText(
                label: "Expiration",
                value: formatter.string(from: donation.expirationDate)
            )

        donorLabel.attributedText =
            styledText(label: "Donor", value: donation.donorName)

        // ✅ ONE source of truth
        let status = donation.expiryStatus()

        statusLabel.attributedText =
            styledText(label: "Food status", value: status.text)

        statusLabel.textColor = status.color

        locationLabel.text = "📍 \(donation.location)"

        foodImageView.image = UIImage(named: donation.imageName)
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.clipsToBounds = true
    }


    // MARK: - Helpers

    /// Creates bold label + normal value text
    private func styledText(label: String, value: String) -> NSAttributedString {
        let boldFont = UIFont.boldSystemFont(ofSize: 15)
        let regularFont = UIFont.systemFont(ofSize: 15)

        let text = NSMutableAttributedString(
            string: "\(label): ",
            attributes: [.font: boldFont]
        )

        text.append(
            NSAttributedString(
                string: value,
                attributes: [.font: regularFont]
            )
        )

        return text
    }

}



