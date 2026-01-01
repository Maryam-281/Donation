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
    private var selectedDonation: Donations?

    // MARK: - Data
    private var allDonations: [Donations] = []
    private var filteredDonations: [Donations] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()


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
                owner: nil,
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toDonationDetails",
           let destination = segue.destination as? DonationDetailsViewController {
            destination.donation = selectedDonation
        }
    }
}
