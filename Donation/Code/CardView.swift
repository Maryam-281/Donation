//
//  CardView.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import UIKit
class CardView: UIView {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    private var donation: Donations?
    var onDetailsTapped: ((Donations) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        // ✅ THIS BYPASSES ALL BUTTON / STACKVIEW ISSUES
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    func configure(with donation: Donations) {
        self.donation = donation
        titleLabel.text = donation.title
        expiryLabel.text = "Expires soon"
        distanceLabel.text = donation.location
    }

    @objc private func cardTapped() {
        print("🟢 CARD TAPPED")
        guard let donation = donation else { return }
        onDetailsTapped?(donation)
    }
}

