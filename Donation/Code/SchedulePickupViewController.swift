//
//  SchedulePickupViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 30/12/2025.
//

import UIKit

class SchedulePickupViewController: UIViewController {



    var donation: Donations?
    private var pickupNote: String?


    @IBOutlet weak var scheduleTitleLabel: UILabel!



    private var contentView: SchedulePickupContentView!


    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please choose a date and time for your donation pickup"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .inline
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()



    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // make the calendar blue
        view.tintColor = UIColor(hex: "89AAC5")

        setupSubtitleLabel()
        setupDatePicker()
        setupContentView()
        configureContent()
    }

    private func setupSubtitleLabel() {
        view.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(
                equalTo: scheduleTitleLabel.bottomAnchor,
                constant: 16
            ),
            subtitleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 38
            ),
            subtitleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10
            )
        ])
    }


    private func setupDatePicker() {
        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: -20
            ),
            datePicker.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            datePicker.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            )
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
            contentView.topAnchor.constraint(
                equalTo: datePicker.bottomAnchor,
                constant: -10
            ),
            contentView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 18
            ),
            contentView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -18
            )
        ])
    }


    private func configureContent() {
        guard let donation else { return }
        contentView.configure(with: donation)
    }



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

