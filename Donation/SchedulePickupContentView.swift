//
//  SchedulePickupContentView.swift
//  Donation
//
//  Created by BP-19-130-14 on 02/01/2026.
//

import Foundation
import UIKit

class SchedulePickupContentView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!

    func configure(with donation: Donations) {
        titleLabel.text = donation.title

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        noteTextView.text = ""
        noteTextView.layer.cornerRadius = 10
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
