//
//  DonationDetailsViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit

class DonationDetailsViewController: UIViewController {

    var donation: Donations?
    private var detailsView: DonationDetailsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailsView()
    }

    private func loadDetailsView() {
        detailsView = Bundle.main.loadNibNamed(
            "DonationDetailsView",
            owner: nil,
            options: nil
        )?.first as? DonationDetailsView

        guard let detailsView else {
            print("❌ Failed to load DonationDetailsView")
            return
        }

        detailsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailsView)

        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if let donation {
            detailsView.configure(with: donation)
        }
    }

    @IBAction func acceptTapped(_ sender: UIButton) {
        donation?.pickupStatus = .accepted
        performSegue(withIdentifier: "toSchedulePickup", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSchedulePickup",
           let destination = segue.destination as? SchedulePickupViewController {
            destination.donation = donation
        }
    }
}









