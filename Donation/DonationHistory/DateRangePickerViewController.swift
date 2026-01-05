import UIKit

protocol DateRangePickerDelegate: AnyObject {
    func didSelectDateRange(start: Date, end: Date)
}

class DateRangePickerViewController: UIViewController {
    
    weak var delegate: DateRangePickerDelegate?
    var startDate: Date?
    var endDate: Date?
    
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
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "From Date"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .appPrimaryDark
        return label
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.maximumDate = Date()
        picker.tintColor = .appPrimary
        return picker
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To Date"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .appPrimaryDark
        return label
    }()
    
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.maximumDate = Date()
        picker.tintColor = .appPrimary
        return picker
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply Filter", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupInitialDates()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Select Date Range"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(startDateLabel)
        contentView.addSubview(startDatePicker)
        contentView.addSubview(endDateLabel)
        contentView.addSubview(endDatePicker)
        contentView.addSubview(errorLabel)
        contentView.addSubview(applyButton)
        
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Start Date Label
            startDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            startDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            // Start Date Picker
            startDatePicker.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 12),
            startDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            startDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // End Date Label
            endDateLabel.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 24),
            endDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            // End Date Picker
            endDatePicker.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 12),
            endDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            endDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Error Label
            errorLabel.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Apply Button
            applyButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
            applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupInitialDates() {
        // Set default dates or use existing ones
        if let start = startDate {
            startDatePicker.date = start
        } else {
            // Default: 30 days ago
            if let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) {
                startDatePicker.date = thirtyDaysAgo
            }
        }
        
        if let end = endDate {
            endDatePicker.date = end
        } else {
            // Default: today
            endDatePicker.date = Date()
        }
    }
    
    // MARK: - Actions
    @objc private func applyTapped() {
        let start = startDatePicker.date
        let end = endDatePicker.date
        
        // Reset time to start of day for start date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: start)
        
        // Set time to end of day for end date
        var components = calendar.dateComponents([.year, .month, .day], from: end)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endOfDay = calendar.date(from: components) ?? end
        
        // Validation
        if endOfDay < startOfDay {
            errorLabel.text = "⚠️ End date must be on or after start date"
            errorLabel.isHidden = false
            
            // Shake animation
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.duration = 0.5
            animation.values = [-10, 10, -8, 8, -5, 5, 0]
            errorLabel.layer.add(animation, forKey: "shake")
            
            return
        }
        
        // Calculate days difference
        let days = calendar.dateComponents([.day], from: startOfDay, to: endOfDay).day ?? 0
        
        print("📅 Date range selected: \(formatDate(startOfDay)) to \(formatDate(endOfDay)) (\(days + 1) days)")
        
        delegate?.didSelectDateRange(start: startOfDay, end: endOfDay)
        dismiss(animated: true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
