//
//  SchedulePickupViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit

class SchedulePickupViewController: UIViewController {

    // MARK: - Data
    var donation: Donations?

    // MARK: - UI
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .inline
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        datePicker.tintColor = .customBlue

        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 140
            )
        ])
    }

    // MARK: - Action
    @IBAction func confirmTapped(_ sender: UIButton) {
        // ✅ THIS SCREEN'S ONLY JOB
        donation?.pickupDate = datePicker.date
        donation?.pickupStatus = .scheduled
        // ❌ No performSegue
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPickupScheduled",
           let destination = segue.destination as? PickupScheduledViewController {
            destination.donation = donation
        }
    }
}


