// DonationHistoryCell.swift
import UIKit

class DonationHistoryCell: UITableViewCell {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let donationIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    static let identifier = "DonationHistoryCell"
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(donationIdLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(userLabel)
        containerView.addSubview(statusView)
        statusView.addSubview(statusLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Donation ID Label
            donationIdLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            donationIdLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            donationIdLabel.trailingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: -8),
            
            // Date Label
            dateLabel.topAnchor.constraint(equalTo: donationIdLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: -8),
            
            // User Label
            userLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            userLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userLabel.trailingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: -8),
            userLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            // Status View
            statusView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusView.widthAnchor.constraint(equalToConstant: 90),
            statusView.heightAnchor.constraint(equalToConstant: 32),
            
            // Status Label
            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with donation: DonationHistory) {
        donationIdLabel.text = "Donation #\(donation.donationid)"
        dateLabel.text = donation.formattedDate
        userLabel.text = "User: \(donation.user ?? "N/A")"
        statusLabel.text = donation.status?.capitalized ?? "Unknown"
        
        // Set status view color
        statusView.backgroundColor = donation.statusColor.withAlphaComponent(0.2)
        statusLabel.textColor = donation.statusColor
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        donationIdLabel.text = nil
        dateLabel.text = nil
        userLabel.text = nil
        statusLabel.text = nil
        statusView.backgroundColor = .clear
    }
}
