//
//  FilteredResultsViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 29/12/2025.
//

import Foundation
import UIKit

class FilteredResultsViewController: UIViewController {

    @IBOutlet weak var cardsStackView: UIStackView!

    var selectedLocation: String?
    var selectedStatus: String?
    var selectedCategory: String?

    var allDonations: [Donations] = []
    var filteredDonations: [Donations] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Filtered Results"

        allDonations = [
            Donations(location: "Manama", status: "Fresh", category: "Prepared Meals", title: "Chicken with Broccoli and Rice"),
            Donations(location: "Manama", status: "Fresh", category: "Baked Goods", title: "Pain Au Chocolat"),
            Donations(location: "Muharraq", status: "Expired", category: "Dairy Products", title: "Milk"),
            Donations(location: "Northern Governorate", status: "Expires Soon", category: "Baked Goods", title: "Bread")
        ]

        applyFilters()
        reloadCards()
    }

    private func applyFilters() {
        filteredDonations = allDonations.filter { donation in

            let locationMatch =
                selectedLocation == nil || donation.location == selectedLocation

            let statusMatch =
                selectedStatus == nil || donation.status == selectedStatus

            let categoryMatch =
                selectedCategory == nil || donation.category == selectedCategory

            return locationMatch && statusMatch && categoryMatch
        }
    }

    private func reloadCards() {

        cardsStackView.arrangedSubviews.forEach {
            cardsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for donation in filteredDonations {
            cardsStackView.addArrangedSubview(createCard(for: donation))
        }
    }

    private func createCard(for donation: Donations) -> UIView {

        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.applySketchShadow()

        let label = UILabel()
        label.text = donation.title
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        card.heightAnchor.constraint(equalToConstant: 90).isActive = true

        return card
    }
}
