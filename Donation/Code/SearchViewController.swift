//
//  SearchViewController.swift
//  Donation
//
//  Created by BP-36-201-10 on 01/01/2026.
//

import UIKit

class SearchViewController: UIViewController {


    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cardsStackView: UIStackView!


    var allDonations: [Donations] = []
    var filteredDonations: [Donations] = []


    var selectedDonation: Donations?


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"

        // Load data
        allDonations = DonationStore.shared.donations
        filteredDonations = [] // start empty

        // Search setup
        searchTextField.delegate = self
        searchTextField.addTarget(
            self,
            action: #selector(searchTextChanged),
            for: .editingChanged
        )

        searchTextField.autocapitalizationType = .none
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.returnKeyType = .search
        searchTextField.placeholder = "Search by food or location"

        reloadCards()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCards()
    }

    
    @objc private func searchTextChanged() {

        let query = searchTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() ?? ""

        if query.isEmpty {
            filteredDonations = []
        } else {
            filteredDonations = allDonations.filter {
                $0.title.localizedCaseInsensitiveContains(query) ||
                $0.location.localizedCaseInsensitiveContains(query)
            }
        }

        reloadCards()
    }


    @IBAction func filterButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "searchShowFilter", sender: nil)
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
           let destination = segue.destination as? DonationDetailsViewController {
            destination.donation = selectedDonation
        }

        if segue.identifier == "searchShowFilter" {

            if let nav = segue.destination as? UINavigationController,
               let filterVC = nav.topViewController as? FilterViewController {
                filterVC.delegate = self
            } else if let filterVC = segue.destination as? FilterViewController {
                filterVC.delegate = self
            }
        }
    }
}


extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension SearchViewController: FilterViewControllerDelegate {

    func didApplyFilters(
        location: String?,
        status: String?,
        category: String?
    ) {

        filteredDonations = allDonations.filter { donation in

            let matchesLocation =
                location == nil || donation.location == location

            let matchesCategory =
                category == nil || donation.category == category

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

    // Convert filter text to ecpiry status
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
