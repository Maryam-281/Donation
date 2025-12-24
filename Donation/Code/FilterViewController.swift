//
//  FilterViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 24/12/2025.
//

import UIKit

class FilterViewController: UIViewController {

    weak var delegate: FilterDelegate?

    var selectedCategory: Category?
    var selectedLocation: Location?
    var selectedStatus: Status?

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var statusTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTableView.isHidden = true

        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.isHidden = true

        statusTableView.dataSource = self
        statusTableView.delegate = self
        statusTableView.isHidden = true
    }

    @IBAction func categoryTapped(_ sender: UIButton) {
        categoryTableView.isHidden.toggle()
        locationTableView.isHidden = true
        statusTableView.isHidden = true
    }

    @IBAction func locationTapped(_ sender: UIButton) {
        locationTableView.isHidden.toggle()
        categoryTableView.isHidden = true
        statusTableView.isHidden = true
    }

    @IBAction func statusTapped(_ sender: UIButton) {
        statusTableView.isHidden.toggle()
        categoryTableView.isHidden = true
        locationTableView.isHidden = true
    }

    @IBAction func resetTapped(_ sender: UIButton) {
        selectedCategory = nil
        selectedLocation = nil
        selectedStatus = nil
        categoryButton.setTitle("Category", for: .normal)
        locationButton.setTitle("Location", for: .normal)
        statusButton.setTitle("Status", for: .normal)
        categoryTableView.isHidden = true
        locationTableView.isHidden = true
        statusTableView.isHidden = true
    }

    @IBAction func applyTapped(_ sender: UIButton) {
        delegate?.didApplyFilters(category: selectedCategory,
                                  location: selectedLocation,
                                  status: selectedStatus)
        dismiss(animated: true)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryTableView { return Category.allCases.count }
        if tableView == locationTableView { return Location.allCases.count }
        if tableView == statusTableView { return Status.allCases.count }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterOptionCell") ??
            UITableViewCell(style: .default, reuseIdentifier: "FilterOptionCell")

        if tableView == categoryTableView {
            let cat = Category.allCases[indexPath.row]
            cell.textLabel?.text = cat.rawValue
            cell.accessoryType = (cat == selectedCategory) ? .checkmark : .none
        } else if tableView == locationTableView {
            let loc = Location.allCases[indexPath.row]
            cell.textLabel?.text = loc.rawValue
            cell.accessoryType = (loc == selectedLocation) ? .checkmark : .none
        } else if tableView == statusTableView {
            let stat = Status.allCases[indexPath.row]
            cell.textLabel?.text = stat.rawValue
            cell.accessoryType = (stat == selectedStatus) ? .checkmark : .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoryTableView {
            selectedCategory = Category.allCases[indexPath.row]
            categoryButton.setTitle(selectedCategory?.rawValue, for: .normal)
            categoryTableView.isHidden = true
        } else if tableView == locationTableView {
            selectedLocation = Location.allCases[indexPath.row]
            locationButton.setTitle(selectedLocation?.rawValue, for: .normal)
            locationTableView.isHidden = true
        } else if tableView == statusTableView {
            selectedStatus = Status.allCases[indexPath.row]
            statusButton.setTitle(selectedStatus?.rawValue, for: .normal)
            statusTableView.isHidden = true
        }

        tableView.reloadData()
    }
}





