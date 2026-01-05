//
//  FilteredResultsViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 29/12/2025.
//

import UIKit


class FilteredResultsViewController: UIViewController {

    @IBOutlet weak var cardsStackView: UIStackView!


    var selectedLocation: String?
    var selectedStatus: String?
    var selectedCategory: String?

    private var selectedDonation: Donations?
    private var allDonations: [Donations] = []
    private var filteredDonations: [Donations] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        allDonations = DonationStore.shared.donations

        applyFilters()

        reloadCards()
    }

    private func applyFilters() {

        filteredDonations = allDonations.filter { donation in

            let matchesLocation =
                selectedLocation == nil ||
                donation.location.lowercased() ==
                selectedLocation!.lowercased()

            let matchesCategory =
                selectedCategory == nil ||
                donation.category.lowercased() ==
                selectedCategory!.lowercased()

            let matchesStatus: Bool = {
                guard let status = selectedStatus,
                      let filterStatus = expiryStatus(from: status) else {
                    return true
                }
                return donation.expiryStatus() == filterStatus
            }()

            return matchesLocation && matchesStatus && matchesCategory
        }
    }


    private func reloadCards() {

        cardsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for donation in filteredDonations {

            guard let card = Bundle.main.loadNibNamed(
                "CardView",
                owner: nil,
                options: nil
            )?.first as? CardView else {
                continue
            }

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

        cardsStackView.layoutIfNeeded()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toDonationDetails",
           let destination = segue.destination
                as? DonationDetailsViewController {
            destination.donation = selectedDonation
        }
    }


    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    private func expiryStatus(from text: String) -> ExpiryStatus? {
        switch text.lowercased() {
        case "fresh":
            return .fresh
        case "expires soon":
            return .expiresSoon
        case "expired":
            return .expired
        default:
            return nil
        }
    }
}
