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
    private var pickupNote: String?

    // MARK: - UI
    private var contentView: SchedulePickupContentView!

    private let datePicker: UIDatePicker = {
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
        setupDatePicker()
        setupContentView()
        configureContent()
    }

    // MARK: - Setup
    private func setupDatePicker() {
        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupContentView() {
        contentView = Bundle.main.loadNibNamed(
            "SchedulePickupContent",
            owner: nil,
            options: nil
        )?.first as? SchedulePickupContentView

        guard let contentView else { return }

        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureContent() {
        guard let donation else { return }
        contentView.configure(with: donation)
    }

    // MARK: - Actions
    @IBAction func confirmTapped(_ sender: UIButton) {
        donation?.pickupDate = datePicker.date
        donation?.pickupStatus = .scheduled
        pickupNote = contentView.noteTextView.text

        performSegue(withIdentifier: "toPickupScheduled", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPickupScheduled",
           let vc = segue.destination as? PickupScheduledViewController {

            vc.donation = donation
            vc.note = pickupNote
        }
    }
}


