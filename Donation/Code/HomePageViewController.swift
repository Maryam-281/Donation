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

        allDonations = [
            Donations(location: "Manama", status: "Fresh", category: "Drinks", title: "Water Bottles"),
            Donations(location: "Muharraq", status: "Expired", category: "Dairy Products", title: "Milk"),
            Donations(location: "Manama", status: "Fresh", category: "Prepared Meals", title: "Lunch Boxes"),
            Donations(location: "Northern Governorate", status: "Expires Soon", category: "Baked Goods", title: "Bread")
        ]

        filteredDonations = allDonations
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.layer.cornerRadius = 20
        shadowView.layer.applySketchShadow()
    }

    // MARK: - ACTIONS
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showFilter", sender: nil)
    }

    // ✅ THIS IS THE IMPORTANT ONE (VIEW DETAILS)
    @IBAction func viewDetailsTapped(_ sender: UIButton) {
        selectedDonation = filteredDonations[sender.tag]
        performSegue(withIdentifier: "toDonationDetails", sender: self)
    }

    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // ✅ PASS DONATION TO DETAILS
        if segue.identifier == "toDonationDetails",
           let destination = segue.destination as? DonationDetailsViewController,
           let donation = selectedDonation {
            destination.donation = donation
        }

        // KEEP FILTER LOGIC
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
                donation.status.lowercased() == status!.lowercased()

            let categoryMatch =
                category == nil ||
                donation.category.lowercased() == category!.lowercased()

            return locationMatch && statusMatch && categoryMatch
        }
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


