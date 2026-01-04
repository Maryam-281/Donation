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

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {

        // Image
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.layer.cornerRadius = 12
        foodImageView.clipsToBounds = true

        // Title
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label

        // Description
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.font = .systemFont(ofSize: 15)
        descriptionTextView.textColor = .secondaryLabel

        // Metadata labels
        [
            categoryLabel,
            productionDateLabel,
            expirationDateLabel,
            donorLabel,
            statusLabel,
            locationLabel
        ].forEach {
            $0?.numberOfLines = 0
        }
    }

    // MARK: - Configure
    func configure(with donation: Donations) {

        titleLabel.text = donation.title
        descriptionTextView.text = donation.donationDescription

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

        // ONE source of truth for food status
        let status = donation.expiryStatus()
        statusLabel.attributedText =
            styledText(label: "Food status", value: status.text)
        statusLabel.textColor = status.color

        locationLabel.text = "📍 \(donation.location)"

        foodImageView.image = UIImage(named: donation.imageName)
    }

    // MARK: - Helpers

    /// Bold label + regular value (Apple-style metadata)
    private func styledText(label: String, value: String) -> NSAttributedString {

        let boldFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let regularFont = UIFont.systemFont(ofSize: 14)

        let text = NSMutableAttributedString(
            string: "\(label): ",
            attributes: [
                .font: boldFont,
                .foregroundColor: UIColor.label
            ]
        )

        text.append(
            NSAttributedString(
                string: value,
                attributes: [
                    .font: regularFont,
                    .foregroundColor: UIColor.secondaryLabel
                ]
            )
        )

        return text
    }
}



