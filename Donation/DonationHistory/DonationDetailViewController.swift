// DonationDetailViewController.swift

import UIKit

class DonationDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        return stack
    }()
    
    private let donationIdLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .label
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let statusBadge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let donerFeedbackCard: FeedbackCardView = {
        let card = FeedbackCardView(title: "Donor Feedback")
        card.translatesAutoresizingMaskIntoConstraints = false
        card.isHidden = true
        return card
    }()
    
    private let collectorFeedbackCard: FeedbackCardView = {
        let card = FeedbackCardView(title: "Collector Feedback")
        card.translatesAutoresizingMaskIntoConstraints = false
        card.isHidden = true
        return card
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    var donationId: Int = 0
    private var donationDetail: DonationDetail?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDonationDetail()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Donation Details"
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Add info section
        let infoStack = UIStackView(arrangedSubviews: [
            donationIdLabel,
            emailLabel,
            dateLabel,
            userLabel
        ])
        infoStack.axis = .vertical
        infoStack.spacing = 8
        
        // Setup status badge
        statusBadge.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusBadge.heightAnchor.constraint(equalToConstant: 40),
            statusBadge.widthAnchor.constraint(equalToConstant: 120),
            statusLabel.centerXAnchor.constraint(equalTo: statusBadge.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -8)
        ])
        
        // Add to stack
        stackView.addArrangedSubview(infoStack)
        stackView.addArrangedSubview(statusBadge)
        stackView.addArrangedSubview(donerFeedbackCard)
        stackView.addArrangedSubview(collectorFeedbackCard)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Stack View
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadDonationDetail() {
        showLoading(true)
        
        Task {
            do {
                donationDetail = try await SupabaseService.shared.fetchDonationDetail(forDonationId: donationId)
                
                await MainActor.run {
                    showLoading(false)
                    updateUI()
                }
            } catch {
                await MainActor.run {
                    showLoading(false)
                    showError(error)
                }
            }
        }
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        guard let detail = donationDetail else { return }
        
        let donation = detail.donation
        
        // Update donation info
        donationIdLabel.text = "Donation #\(donation.donationid)"
        emailLabel.text = "Email: \(donation.email)"
        dateLabel.text = "Date: \(donation.formattedDate)"
        userLabel.text = "User: \(donation.user ?? "N/A")"
        
        // Update status badge
        statusLabel.text = donation.status?.capitalized ?? "Unknown"
        statusBadge.backgroundColor = donation.statusColor.withAlphaComponent(0.2)
        statusLabel.textColor = donation.statusColor
        
        // Update donor feedback
        if let donerFeedback = detail.donerFeedback {
            donerFeedbackCard.isHidden = false
            
            let hours = donerFeedback.pickupTime / 3600
            let minutes = (donerFeedback.pickupTime % 3600) / 60
            let pickupTime = "\(hours)h \(minutes)m"
            
            donerFeedbackCard.configure(items: [
                ("Pickup Time", pickupTime),
                ("Comments", donerFeedback.DonerComments ?? "No comments")
            ])
        }
        
        // Update collector feedback
        if let collectorFeedback = detail.collectorFeedback {
            collectorFeedbackCard.isHidden = false
            
            let hygieneText = collectorFeedback.hygieneRate != nil ?
                "\(collectorFeedback.hygieneRate!)/5 ⭐️" : "Not rated"
            
            collectorFeedbackCard.configure(items: [
                ("Packaging Rate", "\(collectorFeedback.packagingRate)/5 ⭐️"),
                ("Hygiene Rate", hygieneText),
                ("Comments", collectorFeedback.collectorComments ?? "No comments")
            ])
        }
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
            scrollView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            scrollView.isHidden = false
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - Feedback Card View (Helper)
class FeedbackCardView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        
        addSubview(titleLabel)
        addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(items: [(String, String)]) {
        // Clear existing items
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add new items
        for (label, value) in items {
            let itemLabel = UILabel()
            itemLabel.font = .systemFont(ofSize: 15)
            itemLabel.textColor = .label
            itemLabel.numberOfLines = 0
            itemLabel.text = "\(label): \(value)"
            stackView.addArrangedSubview(itemLabel)
        }
    }
}
