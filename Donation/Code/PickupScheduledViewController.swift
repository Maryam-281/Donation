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
    @IBOutlet weak var statusLabel: UITextView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var noteTextField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI Setup
    private func configureUI() {

        statusLabel.text =
        "Your pickup has been successfully scheduled.\nThe donor has been notified."

        statusLabel.isEditable = false
        statusLabel.isSelectable = false
        statusLabel.textAlignment = .center

        statusImageView.image = UIImage(named: "pickup_success")
        statusImageView.contentMode = .scaleAspectFit

        if let note = note,
           !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            noteTextField.text = note
            noteTextField.isHidden = false
        } else {
            noteTextField.isHidden = true
        }

        noteTextField.isEditable = false
        noteTextField.isScrollEnabled = true
    }

    // MARK: - Actions
    @IBAction func continueTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toDonationStatus", sender: donation)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDonationStatus",
           let vc = segue.destination as? StatusTrackingViewController,
           let donation = sender as? Donations {

            vc.donation = donation
            vc.donation?.pickupStatus = .accepted
        }
    }
}
