import UIKit

class DonationHistoryCell: UITableViewCell {
    static let identifier = "DonationHistoryCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.appPrimary.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.widthAnchor.constraint(equalToConstant: 8).isActive = true
        return view
    }()
    
    private let donorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .appPrimaryDark
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
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
        contentView.addSubview(containerView)
        
        containerView.addSubview(statusIndicator)
        containerView.addSubview(donorNameLabel)
        containerView.addSubview(emailLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            statusIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            statusIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusIndicator.heightAnchor.constraint(equalToConstant: 40),
            
            donorNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            donorNameLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 12),
            donorNameLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            emailLabel.topAnchor.constraint(equalTo: donorNameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 12),
            emailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 12),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            statusLabel.centerYAnchor.constraint(equalTo: donorNameLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    // MARK: - Configuration
    func configure(with donation: DonationHistory) {
        // Donor name
        if let donor = donation.donor {
            donorNameLabel.text = "\(donor.firstName) \(donor.lastName)"
            emailLabel.text = donor.email
        } else {
            donorNameLabel.text = donation.user ?? "Unknown"
            emailLabel.text = donation.email ?? "No email"
        }
        
        // Date
        if let date = donation.date {
            dateLabel.text = "📅 \(formatDate(date))"
        } else {
            dateLabel.text = "📅 No date"
        }
        
        // Status
        let status = donation.status ?? "Unknown"
        statusLabel.text = status
        
        switch status.lowercased() {
        case "completed", "collected":
            statusLabel.textColor = .systemGreen
            statusIndicator.backgroundColor = .systemGreen
        case "pending":
            statusLabel.textColor = .appPrimary
            statusIndicator.backgroundColor = .appPrimary
        case "cancelled":
            statusLabel.textColor = .systemRed
            statusIndicator.backgroundColor = .systemRed
        default:
            statusLabel.textColor = .systemGray
            statusIndicator.backgroundColor = .systemGray
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        
        return dateString
    }
}
