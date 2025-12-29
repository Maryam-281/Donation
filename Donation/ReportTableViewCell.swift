//
//  ReportTableViewCell.swift
//  Donation
//
//  Created by Claude
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    static let identifier = "ReportTableViewCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.08
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reportIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reportedUserLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusBadge: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(reportIdLabel)
        containerView.addSubview(reportedUserLabel)
        containerView.addSubview(reasonLabel)
        containerView.addSubview(statusBadge)
        statusBadge.addSubview(statusLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            reportIdLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            reportIdLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            statusBadge.centerYAnchor.constraint(equalTo: reportIdLabel.centerYAnchor),
            statusBadge.leadingAnchor.constraint(equalTo: reportIdLabel.trailingAnchor, constant: 12),
            statusBadge.heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel.topAnchor.constraint(equalTo: statusBadge.topAnchor, constant: 3),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -8),
            statusLabel.bottomAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: -3),
            
            reportedUserLabel.topAnchor.constraint(equalTo: reportIdLabel.bottomAnchor, constant: 8),
            reportedUserLabel.leadingAnchor.constraint(equalTo: reportIdLabel.leadingAnchor),
            reportedUserLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
            reasonLabel.topAnchor.constraint(equalTo: reportedUserLabel.bottomAnchor, constant: 4),
            reasonLabel.leadingAnchor.constraint(equalTo: reportIdLabel.leadingAnchor),
            reasonLabel.trailingAnchor.constraint(equalTo: reportedUserLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: reportIdLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Configuration
    func configure(with report: Report) {
        // Extract report number from ID
        let reportNumber = report.id.prefix(8)
        reportIdLabel.text = "Report #\(reportNumber)"
        
        reportedUserLabel.text = "Reported: \(report.reportedUserName)"
        reasonLabel.text = report.reason
        
        // Status badge
        statusLabel.text = report.reportStatus.rawValue
        switch report.reportStatus {
        case .pending:
            statusBadge.backgroundColor = .systemOrange
        case .reviewed:
            statusBadge.backgroundColor = .systemBlue
        case .resolved:
            statusBadge.backgroundColor = .systemGreen
        case .dismissed:
            statusBadge.backgroundColor = .systemGray
        }
        
        // Date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        dateLabel.text = formatter.localizedString(for: report.createdAtAsDate, relativeTo: Date())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds,
            cornerRadius: containerView.layer.cornerRadius
        ).cgPath
    }
}
