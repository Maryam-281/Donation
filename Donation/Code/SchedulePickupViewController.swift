//
//  SchedulePickupViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit

class SchedulePickupViewController: UIViewController {

    // MARK: - Data
    // The donation selected from the previous screen
    // This is passed in before this VC appears
    var donation: Donations?

    // MARK: - UI
    // This is the custom XIB view that shows:
    // - donation title
    // - optional note text view
    private var contentView: SchedulePickupContentView!

    // The calendar used to select pickup date & time
    // Inline style = full calendar view
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime     // date + time
        picker.preferredDatePickerStyle = .inline // large inline calendar
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = .customBlue            // your brand color
        return picker
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Basic screen background
        view.backgroundColor = .systemBackground

        // Build the UI in order (top → bottom)
        setupDatePicker()
        setupContentView()
        configureContent()
    }

    // MARK: - Setup Calendar
    private func setupDatePicker() {
        // Add the calendar to the screen
        view.addSubview(datePicker)

        NSLayoutConstraint.activate([

            // ⬇️ This controls HOW FAR DOWN the calendar is from the top
            // Increase this number to push EVERYTHING down together
            datePicker.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),

            // Left margin
            datePicker.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),

            // Right margin
            datePicker.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            )
        ])
    }

    // MARK: - Setup Content (Title + Note)
    private func setupContentView() {

        // Load the custom XIB from SchedulePickupContent.xib
        contentView = Bundle.main.loadNibNamed(
            "SchedulePickupContent",
            owner: nil,
            options: nil
        )?.first as? SchedulePickupContentView

        guard let contentView = contentView else { return }

        // Disable autoresizing mask to use Auto Layout
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Add it BELOW the calendar
        view.addSubview(contentView)

        NSLayoutConstraint.activate([

            // ⬆️ THIS controls the gap BETWEEN calendar and labels
            // LOWER this number to reduce space
            // (this does NOT move the calendar)
            contentView.topAnchor.constraint(
                equalTo: datePicker.bottomAnchor,
                constant: 20   // 👈 try 16 or 12
            ),

            // Same left margin as calendar
            contentView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),

            // Same right margin
            contentView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            )
        ])
    }

    // MARK: - Configure Data
    private func configureContent() {
        // Populate the XIB with donation data
        guard let donation = donation else { return }
        contentView.configure(with: donation)
    }

    // MARK: - Actions
    @IBAction func confirmTapped(_ sender: UIButton) {

        // Save selected pickup date
        donation?.pickupDate = datePicker.date
        donation?.pickupStatus = .scheduled

        // Read optional note (can be empty)
        let note = contentView.noteTextView.text ?? ""
        print("Optional note:", note)

        // Move to confirmation screen
        performSegue(withIdentifier: "toPickupScheduled", sender: nil)
    }
}

