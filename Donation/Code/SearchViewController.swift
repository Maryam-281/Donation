//
//  SearchViewController.swift
//  Donation
//
//  Created by BP-36-201-10 on 01/01/2026.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cardsStackView: UIStackView!

    // MARK: - Data
    var allDonations: [Donations] = []
    var filteredDonations: [Donations] = []

    // MARK: - Selection
    var selectedDonation: Donations?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"

        allDonations = DonationStore.shared.donations
        filteredDonations = allDonations

        searchTextField.delegate = self
        searchTextField.addTarget(
            self,
            action: #selector(searchTextChanged),
            for: .editingChanged
        )

        reloadCards()
    }

    // MARK: - Search
    @objc private func searchTextChanged() {
        let query = searchTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() ?? ""

        if query.isEmpty {
            filteredDonations = allDonations
        } else {
            filteredDonations = allDonations.filter {
                $0.title.lowercased().contains(query) ||
                $0.location.lowercased().contains(query)
            }
        }

        reloadCards()
    }

    // MARK: - UI
    private func reloadCards() {
        cardsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for donation in filteredDonations {
            guard let card = Bundle.main.loadNibNamed(
                "CardView",
                owner: nil,
                options: nil
            )?.first as? CardView else { continue }

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
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
