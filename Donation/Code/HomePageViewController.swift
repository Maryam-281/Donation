//
//  HomePageViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 27/12/2025.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var cardsStackView: UIStackView!

    @IBOutlet weak var searchTextField: UITextField!

    var allDonations: [Donations] = []

    var filteredDonations: [Donations] = []

    var selectedDonation: Donations?


    override func viewDidLoad() {
        super.viewDidLoad()


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

    private func reloadCards() {

        // Remove existing cards
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

    @IBAction func filterButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showFilter", sender: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toDonationDetails",
           let destination = segue.destination
                as? DonationDetailsViewController {
            destination.donation = selectedDonation
        }

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


extension HomePageViewController: FilterViewControllerDelegate {

    func didApplyFilters(
        location: String?,
        status: String?,
        category: String?
    ) {

        filteredDonations = allDonations.filter { donation in

            let matchesLocation =
                location == nil ||
                donation.location.lowercased() ==
                location!.lowercased()

            let matchesCategory =
                category == nil ||
                donation.category.lowercased() ==
                category!.lowercased()

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


extension HomePageViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}









