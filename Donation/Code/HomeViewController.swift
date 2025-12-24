//
//  HomeViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 24/12/2025.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didApplyFilters(category: Category?, location: Location?, status: Status?)
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!

    var allDonations: [Donation] = []
    var filteredDonations: [Donation] = []

    var selectedCategory: Category?
    var selectedLocation: Location?
    var selectedStatus: Status?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self

        loadDummyData()
        filteredDonations = allDonations
        tableView.reloadData()
    }

    func loadDummyData() {
        allDonations = [
            Donation(title: "Fresh Milk", category: .dairyProducts, location: .manama, status: .fresh),
            Donation(title: "Vegetable Box", category: .fruitsVegetables, location: .muharraq, status: .expiresSoon),
            Donation(title: "Bread Pack", category: .bakedGoods, location: .southern, status: .expired),
            Donation(title: "Orange Juice", category: .drinks, location: .northern, status: .fresh)
        ]
    }

    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let filterVC = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else { return }
        filterVC.delegate = self
        filterVC.selectedCategory = selectedCategory
        filterVC.selectedLocation = selectedLocation
        filterVC.selectedStatus = selectedStatus
        present(filterVC, animated: true)
    }

    func applyFilters() {
        let text = searchTextField.text?.lowercased() ?? ""

        filteredDonations = allDonations.filter { d in
            let matchesSearch = text.isEmpty || d.title.lowercased().contains(text)
            let matchesCategory = selectedCategory == nil || d.category == selectedCategory
            let matchesLocation = selectedLocation == nil || d.location == selectedLocation
            let matchesStatus = selectedStatus == nil || d.status == selectedStatus
            return matchesSearch && matchesCategory && matchesLocation && matchesStatus
        }
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filteredDonations.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath)
        cell.textLabel?.text = filteredDonations[indexPath.row].title
        return cell
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async { [weak self] in self?.applyFilters() }
        return true
    }
}

extension HomeViewController: FilterDelegate {
    func didApplyFilters(category: Category?, location: Location?, status: Status?) {
        selectedCategory = category
        selectedLocation = location
        selectedStatus = status
        applyFilters()
    }
}



