//
//  FilteredResultsViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 29/12/2025.
//

import UIKit

/// This screen shows the results AFTER the user applies filters.
/// It simply receives filter values and displays matching donation cards.
class FilteredResultsViewController: UIViewController {

    // MARK: - UI Outlets

    /// StackView that holds all filtered CardViews
    @IBOutlet weak var cardsStackView: UIStackView!

    // MARK: - Filters (set before this screen appears)

    /// Location selected in filter screen
    var selectedLocation: String?

    /// Status selected in filter screen (Fresh / Expires soon / Expired)
    var selectedStatus: String?

    /// Category selected in filter screen
    var selectedCategory: String?

    // MARK: - Navigation State

    /// Donation the user taps (used for navigation)
    private var selectedDonation: Donations?

    // MARK: - Data

    /// All available donations (source of truth)
    private var allDonations: [Donations] = []

    /// Donations that match the applied filters
    private var filteredDonations: [Donations] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load all donations once
        allDonations = DonationStore.shared.donations

        // Apply filters immediately
        applyFilters()

        // Build the UI
        reloadCards()
    }

    // MARK: - Filtering Logic

    /// Applies the selected filters to all donations
    private func applyFilters() {

        filteredDonations = allDonations.filter { donation in

            // Location filter (if user selected one)
            let matchesLocation =
                selectedLocation == nil ||
                donation.location.lowercased() ==
                selectedLocation!.lowercased()

            // Category filter (if user selected one)
            let matchesCategory =
                selectedCategory == nil ||
                donation.category.lowercased() ==
                selectedCategory!.lowercased()

            // Status filter (uses ExpiryStatus enum, not strings)
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

    // MARK: - UI Helpers

    /// Clears old cards and adds new filtered ones
    private func reloadCards() {

        // Remove old cards from stack
        cardsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        // Create a card for each filtered donation
        for donation in filteredDonations {

            guard let card = Bundle.main.loadNibNamed(
                "CardView",
                owner: nil,
                options: nil
            )?.first as? CardView else {
                continue
            }

            // Fill card with donation data
            card.configure(with: donation)

            // Handle tap on card
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Navigate to Donation Details
        if segue.identifier == "toDonationDetails",
           let destination = segue.destination
                as? DonationDetailsViewController {
            destination.donation = selectedDonation
        }
    }

    // MARK: - Actions

    /// Closes this screen and returns to previous one
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    // MARK: - Helpers

    /// Converts filter text into ExpiryStatus enum
    /// (UI works with text, model works with enums)
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
