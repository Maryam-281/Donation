//
//  CardView.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import UIKit

class CardView: UIView {

    // MARK: - Outlets (XIB)
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!

    // MARK: - Data
    private var donation: Donations?
    var onDetailsTapped: ((Donations) -> Void)?
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 260)
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        // Card shape
        layer.cornerRadius = 16
        layer.masksToBounds = false

        // Shadow (ONLY HERE)
        layer.applySketchShadow()
    }


    // MARK: - Configure
    func configure(with donation: Donations) {
        self.donation = donation

        titleLabel.text = donation.title
        expiryLabel.text = formattedExpiry(from: donation.expirationDate)
        distanceLabel.text = "2 km"
    }

    private func formattedExpiry(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Expires: \(formatter.string(from: date))"
    }

    // MARK: - Action
    @IBAction func detailsTapped(_ sender: UIButton) {
        guard let donation = donation else { return }
        onDetailsTapped?(donation)
    }
}

