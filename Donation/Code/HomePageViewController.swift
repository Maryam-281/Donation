//
//  HomePageViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 27/12/2025.
//

import UIKit

/// This is the main home screen.
/// It shows all donation cards and allows searching & filtering.
class HomePageViewController: UIViewController {

    // MARK: - UI Outlets

    /// StackView that holds all donation cards
    @IBOutlet weak var cardsStackView: UIStackView!

    /// Search field at the top of the home page
    @IBOutlet weak var searchTextField: UITextField!

    // MARK: - Data

    /// All donations loaded from the store (never modified)
    var allDonations: [Donations] = []

    /// Donations currently shown on screen
    var filteredDonations: [Donations] = []

    // MARK: - Navigation State

    /// Donation selected by tapping a card
    var selectedDonation: Donations?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load all donations once
        allDonations = DonationStore.shared.donations

        // Initially show everything
        filteredDonations = allDonations

        // Configure search text field
        searchTextField.delegate = self
        searchTextField.addTarget(
            self,
            action: #selector(searchTextChanged),
            for: .editingChanged
        )

        reloadCards()
    }

    // MARK: - UI Helpers

    /// Clears old cards and recreates them from `filteredDonations`
    private func reloadCards() {

        // Remove existing cards
        cardsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        // Create a card for each donation
        for donation in filteredDonations {

            guard let card = Bundle.main.loadNibNamed(
                "CardView",
                owner: nil,
                options: nil
            )?.first as? CardView else {
                continue
            }

            // Fill card UI
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

    // MARK: - Search Logic

    /// Called every time the user types in the search field
    @objc private func searchTextChanged() {

        let query = searchTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() ?? ""

        // If search is empty → show all donations
        if query.isEmpty {
            filteredDonations = allDonations
        } else {
            // Filter by title OR location
            filteredDonations = allDonations.filter { donation in
                donation.title.lowercased().contains(query) ||
                donation.location.lowercased().contains(query)
            }
        }

        reloadCards()
    }

    // MARK: - Actions

    /// Opens the filter screen
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showFilter", sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Navigate to donation details
        if segue.identifier == "toDonationDetails",
           let destination = segue.destination
                as? DonationDetailsViewController {
            destination.donation = selectedDonation
        }

        // Navigate to filter screen
        if segue.identifier == "showFilter" {

            if let filterVC = segue.destination
                as? FilterViewController {
                filterVC.delegate = self

            } else if let nav = segue.destination
                        as? UINavigationController,
                      let filterVC = nav.topViewController
                        as? FilterViewController {
                filterVC.delegate = self
            }
        }
    }
}

// MARK: - Filter Delegate

extension HomePageViewController: FilterViewControllerDelegate {

    /// Called when the user applies filters
    func didApplyFilters(
        location: String?,
        status: String?,
        category: String?
    ) {

        filteredDonations = allDonations.filter { donation in

            // Location filter
            let matchesLocation =
                location == nil ||
                donation.location.lowercased() ==
                location!.lowercased()

            // Category filter
            let matchesCategory =
                category == nil ||
                donation.category.lowercased() ==
                category!.lowercased()

            // Status filter (uses ExpiryStatus enum)
            let matchesStatus: Bool = {
                guard let status = status,
                      let filterStatus = expiryStatus(from: status) else {
                    return true
                }
                return donation.expiryStatus() == filterStatus
            }()

            return matchesLocation && matchesStatus && matchesCategory
        }

        reloadCards()
    }

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

// MARK: - UITextField Delegate

extension HomePageViewController: UITextFieldDelegate {

    /// Hides the keyboard when the user taps "Search"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}









