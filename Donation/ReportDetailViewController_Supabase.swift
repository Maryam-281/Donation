//
//  ReportDetailViewController.swift
//  Donation
//
//  Created by Claude
//

import UIKit

protocol ReportDetailDelegate: AnyObject {
    func didUpdateReport(_ report: Report)
}

class ReportDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerCard: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reportIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(hex: "89AAC5")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusBadge: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reportedUserLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reasonCard: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reasonTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reason"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionCard: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let resolveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Resolve", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var report: Report
    weak var delegate: ReportDetailDelegate?
    
    // MARK: - Initialization
    init(report: Report) {
        self.report = report
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithReport()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Report Details"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerCard)
        headerCard.addSubview(reportIdLabel)
        headerCard.addSubview(statusBadge)
        statusBadge.addSubview(statusLabel)
        headerCard.addSubview(reportedUserLabel)
        headerCard.addSubview(dateLabel)
        
        contentView.addSubview(reasonCard)
        reasonCard.addSubview(reasonTitleLabel)
        reasonCard.addSubview(reasonLabel)
        
        contentView.addSubview(descriptionCard)
        descriptionCard.addSubview(descriptionTitleLabel)
        descriptionCard.addSubview(descriptionLabel)
        
        contentView.addSubview(actionsStackView)
        actionsStackView.addArrangedSubview(dismissButton)
        actionsStackView.addArrangedSubview(resolveButton)
        
        resolveButton.addTarget(self, action: #selector(resolveButtonTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            headerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            reportIdLabel.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 20),
            reportIdLabel.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 20),
            
            statusBadge.centerYAnchor.constraint(equalTo: reportIdLabel.centerYAnchor),
            statusBadge.leadingAnchor.constraint(equalTo: reportIdLabel.trailingAnchor, constant: 12),
            statusBadge.heightAnchor.constraint(equalToConstant: 24),
            
            statusLabel.topAnchor.constraint(equalTo: statusBadge.topAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: 10),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -10),
            statusLabel.bottomAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: -4),
            
            reportedUserLabel.topAnchor.constraint(equalTo: reportIdLabel.bottomAnchor, constant: 12),
            reportedUserLabel.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 20),
            reportedUserLabel.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: reportedUserLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: reportedUserLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: reportedUserLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -20),
            
            reasonCard.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 24),
            reasonCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            reasonCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            reasonTitleLabel.topAnchor.constraint(equalTo: reasonCard.topAnchor, constant: 20),
            reasonTitleLabel.leadingAnchor.constraint(equalTo: reasonCard.leadingAnchor, constant: 20),
            reasonTitleLabel.trailingAnchor.constraint(equalTo: reasonCard.trailingAnchor, constant: -20),
            
            reasonLabel.topAnchor.constraint(equalTo: reasonTitleLabel.bottomAnchor, constant: 8),
            reasonLabel.leadingAnchor.constraint(equalTo: reasonCard.leadingAnchor, constant: 20),
            reasonLabel.trailingAnchor.constraint(equalTo: reasonCard.trailingAnchor, constant: -20),
            reasonLabel.bottomAnchor.constraint(equalTo: reasonCard.bottomAnchor, constant: -20),
            
            descriptionCard.topAnchor.constraint(equalTo: reasonCard.bottomAnchor, constant: 24),
            descriptionCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: descriptionCard.topAnchor, constant: 20),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: descriptionCard.leadingAnchor, constant: 20),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: descriptionCard.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionCard.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionCard.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionCard.bottomAnchor, constant: -20),
            
            actionsStackView.topAnchor.constraint(equalTo: descriptionCard.bottomAnchor, constant: 32),
            actionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            actionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            actionsStackView.heightAnchor.constraint(equalToConstant: 56),
            actionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func configureWithReport() {
        let reportNumber = report.id.prefix(8)
        reportIdLabel.text = "Report ID: #\(reportNumber)"
        
        reportedUserLabel.text = "Reported User: \(report.reportedUserName)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = "Reported on \(formatter.string(from: report.createdAtAsDate))"
        
        statusLabel.text = report.reportStatus.rawValue
        switch report.reportStatus {
        case .pending:
            statusBadge.backgroundColor = .systemOrange
        case .reviewed:
            statusBadge.backgroundColor = UIColor(hex: "89AAC5")
        case .resolved:
            statusBadge.backgroundColor = .systemGreen
            actionsStackView.isHidden = true
        case .dismissed:
            statusBadge.backgroundColor = .systemGray
            actionsStackView.isHidden = true
        }
        
        reasonLabel.text = report.reason
        descriptionLabel.text = report.description
    }
    
    // MARK: - Actions
    @objc private func resolveButtonTapped() {
        showConfirmationAlert(
            title: "Resolve Report",
            message: "Are you sure you want to mark this report as resolved?",
            confirmTitle: "Resolve",
            confirmStyle: .default
        ) { [weak self] in
            self?.updateReportStatus(to: .resolved)
        }
    }
    
    @objc private func dismissButtonTapped() {
        showConfirmationAlert(
            title: "Dismiss Report",
            message: "Are you sure you want to dismiss this report?",
            confirmTitle: "Dismiss",
            confirmStyle: .destructive
        ) { [weak self] in
            self?.updateReportStatus(to: .dismissed)
        }
    }
    
    private func showConfirmationAlert(title: String, message: String, confirmTitle: String, confirmStyle: UIAlertAction.Style, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            completion()
        })
        
        present(alert, animated: true)
    }
    
    private func updateReportStatus(to newStatus: Report.ReportStatus) {
        // Show loading
        let loadingAlert = UIAlertController(title: nil, message: "Updating...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingAlert.view.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: loadingAlert.view.centerXAnchor).isActive = true
        loadingIndicator.bottomAnchor.constraint(equalTo: loadingAlert.view.bottomAnchor, constant: -20).isActive = true
        loadingIndicator.startAnimating()
        present(loadingAlert, animated: true)
        
        Task {
            do {
                let updatedReport = try await SupabaseManager.shared.updateReportStatus(
                    id: report.id,
                    status: newStatus
                )
                
                await MainActor.run {
                    loadingAlert.dismiss(animated: true)
                    self.report = updatedReport
                    self.showSuccessAnimation()
                    self.configureWithReport()
                    self.delegate?.didUpdateReport(updatedReport)
                }
            } catch {
                await MainActor.run {
                    loadingAlert.dismiss(animated: true)
                    self.showError(error)
                }
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAnimation() {
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmarkView.tintColor = .systemGreen
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        checkmarkView.center = view.center
        checkmarkView.alpha = 0
        checkmarkView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        view.addSubview(checkmarkView)
        
        UIView.animate(withDuration: 0.3, animations: {
            checkmarkView.alpha = 1
            checkmarkView.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.5, animations: {
                checkmarkView.alpha = 0
                checkmarkView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                checkmarkView.removeFromSuperview()
            }
        }
    }
}
