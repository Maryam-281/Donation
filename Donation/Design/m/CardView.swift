//
//  CardView.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    private var donation: Donations?
    var onDetailsTapped: ((Donations) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        // Tap on entire card
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tap)

        // Shadow on CardView
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Rounded corners on container
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true

        // Optional but improves shadow performance
        layer.shadowPath = UIBezierPath(
            roundedRect: containerView.frame,
            cornerRadius: 30
        ).cgPath
    }

    func configure(with donation: Donations) {
        self.donation = donation

        titleLabel.text = donation.title
        let expiry = expiryInfo(for: donation)
        expiryLabel.text = expiry.text
        expiryLabel.textColor = expiry.color

        distanceLabel.text = donation.location

        foodImageView.image = UIImage(named: donation.imageName)
        foodImageView.layer.cornerRadius = 15
        foodImageView.clipsToBounds = true
        foodImageView.contentMode = .scaleAspectFill
    }
    
    private func animatePressDown() {
        UIView.animate(
            withDuration: 0.12,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }
        )

        animateShadowPressed()
    }


    private func animateRelease(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.transform = .identity
            },
            completion: { _ in
                self.animateShadowReleased()
                completion?()
            }
        )
    }

    private func animateShadowPressed() {
        UIView.animate(withDuration: 0.12) {
            self.layer.shadowOpacity = 0.15
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
        }
    }

    private func animateShadowReleased() {
        UIView.animate(withDuration: 0.15) {
            self.layer.shadowOpacity = 0.35
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.layer.shadowRadius = 8
        }
    }



    @objc private func cardTapped() {
        guard let donation = donation else { return }

        animatePressDown()
        animateRelease {
            self.onDetailsTapped?(donation)
        }
    }

    
    private func expiryInfo(for donation: Donations) -> (text: String, color: UIColor) {

        let today = Calendar.current.startOfDay(for: Date())
        let expiry = Calendar.current.startOfDay(for: donation.expirationDate)

        let daysLeft = Calendar.current.dateComponents([.day], from: today, to: expiry).day ?? 0

        if daysLeft < 0 {
            return ("Expired", .systemRed)
        } else if daysLeft <= 2 {
            return ("Expires soon", .systemOrange)
        } else {
            return ("Fresh", .systemGreen)
        }
    }

}


