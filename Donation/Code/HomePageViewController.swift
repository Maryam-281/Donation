//
//  HomePageViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 27/12/2025.
//

import UIKit

// MARK: - VIEW CONTROLLER
class HomePageViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardsStackView: UIStackView!

    // MARK: - DATA
    var allDonations: [Donations] = []
    var filteredDonations: [Donations] = []

    // MARK: - CURRENT SELECTION / FILTERS
    var selectedDonation: Donations?
    var selectedLocation: String?
    var selectedStatus: String?
    var selectedCategory: String?

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        shadowView.isUserInteractionEnabled = false

        allDonations = DonationStore.shared.donations
        filteredDonations = allDonations
        reloadCards()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.layer.cornerRadius = 20
        shadowView.layer.applySketchShadow()
    }

    // MARK: - UI UPDATE
    func reloadCards() {

        cardsStackView.arrangedSubviews.forEach {
            cardsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for (index, donation) in filteredDonations.enumerated() {

            let cardButton = UIButton(type: .custom)
            cardButton.setTitle(donation.title, for: .normal)
            cardButton.contentHorizontalAlignment = .left
            cardButton.tag = index

            // 🔴 REQUIRED: give the button real size
            cardButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            cardButton.titleLabel?.numberOfLines = 2

            cardButton.addTarget(
                self,
                action: #selector(viewDetailsTapped(_:)),
                for: .touchUpInside
            )

            cardsStackView.addArrangedSubview(cardButton)
        }
    }

    // MARK: - ACTIONS
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showFilter", sender: nil)
    }

    @objc func viewDetailsTapped(_ sender: UIButton) {
        print("✅ TAP WORKS:", sender.tag)
    }



    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toDonationDetails",
           let destination = segue.destination as? DonationDetailsViewController,
           let donation = selectedDonation {
            destination.donation = donation
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

// MARK: - FILTER DELEGATE
extension HomePageViewController: FilterViewControllerDelegate {

    func didApplyFilters(location: String?, status: String?, category: String?) {

        selectedLocation = location
        selectedStatus = status
        selectedCategory = category

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

// MARK: - SHADOW EXTENSION
extension CALayer {

    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.15,
        x: CGFloat = 0,
        y: CGFloat = 20,
        blur: CGFloat = 15,
        spread: CGFloat = 0
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        masksToBounds = false

        if spread != 0 {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}



