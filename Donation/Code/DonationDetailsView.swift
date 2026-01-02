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

        // Title & description
        titleLabel.text = donation.title
        descriptionTextView.text = donation.donationDescription
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false

        // Dates formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        // Styled labels (UI-only text)
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
                value: expirationText(for: donation.expirationDate)
            )

        donorLabel.attributedText =
            styledText(label: "Donor", value: donation.donorName)

        statusLabel.attributedText =
            styledText(label: "Food status", value: donation.foodStatus)

        locationLabel.text = "📍 \(donation.location)"

        applyStatusColor(status: donation.foodStatus)

        // Image
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

    /// Returns "Expires in X days" or "Expired"
    private func expirationText(for date: Date) -> String {
        let daysLeft = Calendar.current.dateComponents(
            [.day],
            from: Date(),
            to: date
        ).day ?? 0

        if daysLeft < 0 {
            return "Expired"
        } else if daysLeft == 0 {
            return "Expires today"
        } else {
            return "Expires in \(daysLeft) days"
        }
    }

    /// Color-code food status
    private func applyStatusColor(status: String) {
        switch status.lowercased() {
        case "fresh":
            statusLabel.textColor = .systemGreen
        case "expires soon":
            statusLabel.textColor = .systemOrange
        case "expired":
            statusLabel.textColor = .systemRed
        default:
            statusLabel.textColor = .label
        }
    }
}



