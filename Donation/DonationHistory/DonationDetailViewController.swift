import UIKit

class DonationDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .appPrimary
        return indicator
    }()
    
    private lazy var donationInfoCard: InfoCardView = {
        let card = InfoCardView(title: "Donation Information")
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private lazy var donerFeedbackCard: FeedbackCardView = {
        let card = FeedbackCardView(title: "Donor Feedback")
        card.translatesAutoresizingMaskIntoConstraints = false
        card.isHidden = true
        return card
    }()
    
    private lazy var collectorFeedbackCard: FeedbackCardView = {
        let card = FeedbackCardView(title: "Collector Feedback")
        card.translatesAutoresizingMaskIntoConstraints = false
        card.isHidden = true
        return card
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
        navigationController?.navigationBar.tintColor = .appPrimary
        
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(donationInfoCard)
        contentStackView.addArrangedSubview(donerFeedbackCard)
        contentStackView.addArrangedSubview(collectorFeedbackCard)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Data Loading
    private func loadDonationDetail() {
        activityIndicator.startAnimating()
        scrollView.isHidden = true
        
        Task {
            do {
                donationDetail = try await SupabaseService.shared.fetchDonationDetail(forDonationId: donationId)
                
                await MainActor.run {
                    activityIndicator.stopAnimating()
                    scrollView.isHidden = false
                    updateUI()
                }
            } catch {
                print("❌ Error loading donation detail: \(error)")
                
                await MainActor.run {
                    activityIndicator.stopAnimating()
                    showError(error)
                }
            }
        }
    }
    
    private func updateUI() {
        guard let detail = donationDetail else { return }
        
        // ✅ Show donation ID in navigation title
        title = "Donation #\(detail.donationid)"
        
        // Update donation info
        var infoText = ""
        
        if let donor = detail.donor {
            infoText += "👤 Donor: \(donor.firstName) \(donor.lastName)\n"
            infoText += "📧 Email: \(donor.email)\n"
            if let phone = donor.phoneNumber {
                infoText += "📱 Phone: \(phone)\n"
            }
        }
        
        if let date = detail.date {
            infoText += "📅 Date: \(formatDate(date))\n"
        }
        
        if let status = detail.status {
            infoText += "📊 Status: \(status)\n"
        }
        
        if let collector = detail.collector {
            infoText += "\n━━━━━━━━━━━━━━━━━\n"
            infoText += "🚚 Collector: \(collector.firstName) \(collector.lastName)\n"
            infoText += "📧 Email: \(collector.email)\n"
            if let phone = collector.phoneNumber {
                infoText += "📱 Phone: \(phone)\n"
            }
        }
        
        donationInfoCard.setText(infoText)
        
        // Update collector feedback (handle array)
        if let feedbackArray = detail.collectorFeedback, let feedback = feedbackArray.first {
            var feedbackText = ""
            feedbackText += "📦 Packaging: \(String(repeating: "⭐️", count: feedback.packagingRate))\n"
            
            if let hygiene = feedback.hygieneRate {
                feedbackText += "🧼 Hygiene: \(String(repeating: "⭐️", count: hygiene))\n"
            }
            
            if let comments = feedback.collectorComments, !comments.isEmpty {
                feedbackText += "\n💬 Comments:\n\(comments)"
            }
            
            collectorFeedbackCard.setText(feedbackText)
            collectorFeedbackCard.isHidden = false
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        
        return dateString
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

// MARK: - InfoCardView (For donation info)
class InfoCardView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .appPrimaryDark
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 0
        return label
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
        backgroundColor = UIColor.appPrimaryLight.withAlphaComponent(0.2)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.appPrimary.cgColor
        
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setText(_ text: String) {
        contentLabel.text = text.isEmpty ? "No information available" : text
    }
}

// MARK: - FeedbackCardView (For feedback sections)
class FeedbackCardView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .appPrimaryDark
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 0
        return label
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
        backgroundColor = UIColor.appPrimaryLight.withAlphaComponent(0.2)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.appPrimary.cgColor
        
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setText(_ text: String) {
        contentLabel.text = text.isEmpty ? "No feedback available" : text
    }
}
