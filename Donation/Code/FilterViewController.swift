//
//  FilterViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(
        location: String?,
        status: String?,
        category: String?
    )
}

class FilterViewController: UIViewController {

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!

    var selectedLocation: String?
    var selectedStatus: String?
    var selectedCategory: String?
    
    weak var delegate: FilterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationMenu()
        setupStatusMenu()
        setupCategoryMenu()
    }

    // MARK: - Location Menu
    func setupLocationMenu() {

        let all = UIAction(title: "All Locations", state: selectedLocation == nil ? .on : .off) { _ in
            self.selectedLocation = nil
            self.locationButton.setTitle("Locations", for: .normal)
        }

        let muharraq = UIAction(title: "Muharraq") { _ in
            self.selectedLocation = "Muharraq"
            self.locationButton.setTitle("Muharraq", for: .normal)
        }

        let manama = UIAction(title: "Manama") { _ in
            self.selectedLocation = "Manama"
            self.locationButton.setTitle("Manama", for: .normal)
        }

        let southern = UIAction(title: "Southern Governorate") { _ in
            self.selectedLocation = "Southern"
            self.locationButton.setTitle("Southern Governorate", for: .normal)
        }

        let northern = UIAction(title: "Northern Governorate") { _ in
            self.selectedLocation = "Northern"
            self.locationButton.setTitle("Northern Governorate", for: .normal)
        }

        locationButton.menu = UIMenu(children: [all, muharraq, manama, southern, northern])
        locationButton.showsMenuAsPrimaryAction = true
    }

    // MARK: - Status Menu
    func setupStatusMenu() {

        let all = UIAction(title: "All Status", state: selectedStatus == nil ? .on : .off) { _ in
            self.selectedStatus = nil
            self.statusButton.setTitle("Status", for: .normal)
        }

        let fresh = UIAction(title: "Fresh") { _ in
            self.selectedStatus = "Fresh"
            self.statusButton.setTitle("Fresh", for: .normal)
        }

        let expiresSoon = UIAction(title: "Expires Soon") { _ in
            self.selectedStatus = "Expires Soon"
            self.statusButton.setTitle("Expires Soon", for: .normal)
        }

        let expired = UIAction(title: "Expired") { _ in
            self.selectedStatus = "Expired"
            self.statusButton.setTitle("Expired", for: .normal)
        }

        statusButton.menu = UIMenu(children: [all, fresh, expiresSoon, expired])
        statusButton.showsMenuAsPrimaryAction = true
    }

    // MARK: - Category Menu
    func setupCategoryMenu() {

        let all = UIAction(title: "All Categories", state: selectedCategory == nil ? .on : .off) { _ in
            self.selectedCategory = nil
            self.categoryButton.setTitle("Categories", for: .normal)
        }

        let meals = UIAction(title: "Prepared Meals") { _ in
            self.selectedCategory = "Prepared Meals"
            self.categoryButton.setTitle("Prepared Meals", for: .normal)
        }

        let fruits = UIAction(title: "Fruits & Vegetables") { _ in
            self.selectedCategory = "Fruits & Vegetables"
            self.categoryButton.setTitle("Fruits & Vegetables", for: .normal)
        }

        let baked = UIAction(title: "Baked Goods") { _ in
            self.selectedCategory = "Baked Goods"
            self.categoryButton.setTitle("Baked Goods", for: .normal)
        }

        let drinks = UIAction(title: "Drinks") { _ in
            self.selectedCategory = "Drinks"
            self.categoryButton.setTitle("Drinks", for: .normal)
        }

        let dairy = UIAction(title: "Dairy Products") { _ in
            self.selectedCategory = "Dairy Products"
            self.categoryButton.setTitle("Dairy Products", for: .normal)
        }

        categoryButton.menu = UIMenu(children: [all, meals, fruits, baked, drinks, dairy])
        categoryButton.showsMenuAsPrimaryAction = true
    }

    // MARK: - Reset Filter
    @IBAction func resetFilterTapped(_ sender: UIButton) {

        selectedLocation = nil
        selectedStatus = nil
        selectedCategory = nil

        locationButton.setTitle("Locations", for: .normal)
        statusButton.setTitle("Status", for: .normal)
        categoryButton.setTitle("Categories", for: .normal)

        setupLocationMenu()
        setupStatusMenu()
        setupCategoryMenu()
    }

    // Apply Filters
    @IBAction func applyButtonTapped(_ sender: UIButton) {

        let storyboard = UIStoryboard(name: "Discovery", bundle: nil)

        guard let resultsVC = storyboard.instantiateViewController(
            withIdentifier: "FilteredResultsViewController"
        ) as? FilteredResultsViewController else {
            fatalError("FilteredResultsViewController not found in Discovery.storyboard")
        }

        // Pass selected filters
        resultsVC.selectedLocation = selectedLocation
        resultsVC.selectedStatus = selectedStatus
        resultsVC.selectedCategory = selectedCategory

        resultsVC.modalPresentationStyle = .fullScreen
        present(resultsVC, animated: true)
    }



    
    @IBAction func closeTapped(_ sender: UIButton) {
            dismiss(animated: true)
        }

    }



