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

    // MARK: - Outlets (Already exist in your storyboard)

    /// Main title label (text: "Schedule Donation")
    @IBOutlet weak var scheduleTitleLabel: UILabel!

    // MARK: - UI (Programmatic)

    private var contentView: SchedulePickupContentView!

    /// Subheading shown under the main title
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

    /// Inline calendar picker
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

        // make the calendar blue
        view.tintColor = UIColor(hex: "89AAC5")

        setupSubtitleLabel()
        setupDatePicker()
        setupContentView()
        configureContent()
    }

    // MARK: - Setup UI

    /// Adds the subtitle under "Schedule Donation"
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


    /// Adds and positions the calendar closer to the top
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

    /// Loads the content view below the calendar
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

    /// Fills content view with donation info
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPickupScheduled",
           let vc = segue.destination as? PickupScheduledViewController {
            vc.donation = donation
            vc.note = pickupNote
        }
    }
}

