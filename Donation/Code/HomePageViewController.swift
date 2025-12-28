//
//  HomePageViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 27/12/2025.
//

import UIKit

// MARK: - MODEL
struct Donation {
    let location: String
    let status: String
    let category: String
    let title: String
}

// MARK: - VIEW CONTROLLER
class HomePageViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardsStackView: UIStackView!


    // MARK: - DATA
    var allDonations: [Donation] = []
    var filteredDonations: [Donation] = []

    // MARK: - CURRENT FILTERS
    var selectedLocation: String?
    var selectedStatus: String?
    var selectedCategory: String?

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // TEMP DATA (for testing filters)
        allDonations = [
            Donation(location: "Manama", status: "Fresh", category: "Drinks", title: "Water Bottles"),
            Donation(location: "Muharraq", status: "Expired", category: "Dairy Products", title: "Milk"),
            Donation(location: "Manama", status: "Fresh", category: "Prepared Meals", title: "Lunch Boxes"),
            Donation(location: "Northern Governorate", status: "Expires Soon", category: "Baked Goods", title: "Bread")
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

    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilter" {

            // Handles normal & embedded cases safely
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

        print("===== APPLY FILTERS =====")
        print("Category:", category ?? "Any")
        print("Results:", filteredDonations.count)

        for item in filteredDonations {
            print("•", item.title)
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

        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
    }
    
}

