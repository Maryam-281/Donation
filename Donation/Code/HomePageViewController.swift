//
//  HomePageViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 27/12/2025.
//

import UIKit

class HomePageViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var cardsStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!

    // MARK: - Data
    var allDonations: [Donations] = []
    var filteredDonations: [Donations] = []

    // MARK: - Selection
    var selectedDonation: Donations?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        allDonations = DonationStore.shared.donations
        filteredDonations = allDonations

        // 🔍 Search setup
        searchTextField.delegate = self
        searchTextField.addTarget(
            self,
            action: #selector(searchTextChanged),
            for: .editingChanged
        )

        reloadCards()
    }

    // MARK: - UI
    func reloadCards() {

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

    // MARK: - Search
    @objc private func searchTextChanged() {

        let query = searchTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() ?? ""

        if query.isEmpty {
            filteredDonations = allDonations
        } else {
            filteredDonations = allDonations.filter { donation in
                donation.title.lowercased().contains(query) ||
                donation.location.lowercased().contains(query)
            }
        }

        reloadCards()
    }

    // MARK: - Actions
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showFilter", sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toDonationDetails",
           let destination = segue.destination as? DonationDetailsViewController {
            destination.donation = selectedDonation
        }

        if segue.identifier == "showFilter" {
            if let filterVC = segue.destination as? FilterViewController {
                filterVC.delegate = self
            } else if let nav = segue.destination as? UINavigationController,
                      let filterVC = nav.topViewController as? FilterViewController {
                filterVC.delegate = self
            }
        }
    }
}

// MARK: - Filter Delegate
extension HomePageViewController: FilterViewControllerDelegate {

    func didApplyFilters(location: String?, status: String?, category: String?) {

        filteredDonations = allDonations.filter { donation in

            let locationMatch =
                location == nil ||
                donation.location.lowercased() == location!.lowercased()

            let statusMatch =
                status == nil ||
                donation.foodStatus.lowercased() == status!.lowercased()

            let categoryMatch =
                category == nil ||
                donation.category.lowercased() == category!.lowercased()

            return locationMatch && statusMatch && categoryMatch
        }

        reloadCards()
    }
}

// MARK: - UITextField Delegate
extension HomePageViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}









