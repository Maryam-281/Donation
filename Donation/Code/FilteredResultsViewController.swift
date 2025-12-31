//
//  FilteredResultsViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 29/12/2025.
//

import UIKit

class FilteredResultsViewController: UIViewController {

    @IBOutlet weak var cardsStackView: UIStackView!

    // MARK: - Filters
    var selectedLocation: String?
    var selectedStatus: String?
    var selectedCategory: String?
    var selectedDonation: Donations?

    // MARK: - Data
    var allDonations: [Donations] = []
    var filteredDonations: [Donations] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Filtered Results"

        // ✅ Use shared store (single source of truth)
        allDonations = DonationStore.shared.donations

        applyFilters()
        reloadCards()
    }

    // MARK: - Filtering
    private func applyFilters() {
        filteredDonations = allDonations.filter { donation in

            let locationMatch =
                selectedLocation == nil ||
                donation.location.lowercased() == selectedLocation!.lowercased()

            let statusMatch =
                selectedStatus == nil ||
                donation.foodStatus.lowercased() == selectedStatus!.lowercased()

            let categoryMatch =
                selectedCategory == nil ||
                donation.category.lowercased() == selectedCategory!.lowercased()

            return locationMatch && statusMatch && categoryMatch
        }
    }

    // MARK: - UI
    private func reloadCards() {

        cardsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for donation in filteredDonations {

            let card = Bundle.main.loadNibNamed(
                "CardView",
                owner: self,
                options: nil
            )?.first as! CardView

            card.configure(with: donation)

            card.onDetailsTapped = { [weak self] donation in
                self?.selectedDonation = donation
                self?.performSegue(
                    withIdentifier: "toDonationDetails",
                    sender: nil
                )
            }

            cardsStackView.addArrangedSubview(card)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDonationDetails",
           let destination = segue.destination as? DonationDetailsViewController {
            destination.donation = selectedDonation
        }
    }


    private func createCard(for donation: Donations) -> UIView {

        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.applySketchShadow()

        let titleLabel = UILabel()
        titleLabel.text = donation.title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let statusLabel = UILabel()
        statusLabel.text = donation.foodStatus
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = .gray
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(titleLabel)
        card.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),

            statusLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6)
        ])

        card.heightAnchor.constraint(equalToConstant: 90).isActive = true

        return card
    }
}

