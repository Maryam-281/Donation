import UIKit

class DonationHistoryViewController: UIViewController {
    
    // MARK: - Filter Options
    enum DonationFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case completed = "Completed"
        case collected = "Collected"
        case cancelled = "Cancelled"
        
        var displayName: String { rawValue }
    }
    
    // MARK: - UI Components
    private let statusFilterSegmentedControl: UISegmentedControl = {
        let items = DonationFilter.allCases.map { $0.displayName }
        let control = UISegmentedControl(items: items)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.backgroundColor = .appPrimaryLight
        control.selectedSegmentTintColor = .appPrimary
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.appPrimaryDark], for: .normal)
        return control
    }()
    
    private let dateFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("📅 Select Date Range", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .appPrimaryLight
        button.setTitleColor(.appPrimaryDark, for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return button
    }()
    
    private let clearDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .systemRed.withAlphaComponent(0.2)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 100
        table.separatorStyle = .singleLine
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .appPrimary
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No donations found"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .appPrimaryDark
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    private var allDonations: [DonationHistory] = []
    private var filteredDonations: [DonationHistory] = []
    private var currentStatusFilter: DonationFilter = .all
    
    // Date range properties
    private var startDate: Date?
    private var endDate: Date?
    
    // Test configuration
    private let testMode = true
    private let testEmail = "test@example.com"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupTableView()
        loadDonations()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Donation History"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .appPrimary
        
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshData)
        )
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(statusFilterSegmentedControl)
        view.addSubview(dateFilterButton)
        view.addSubview(clearDateButton)
        view.addSubview(resultCountLabel)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        // Add targets
        statusFilterSegmentedControl.addTarget(self, action: #selector(statusFilterChanged), for: .valueChanged)
        dateFilterButton.addTarget(self, action: #selector(showDateRangePicker), for: .touchUpInside)
        clearDateButton.addTarget(self, action: #selector(clearDateFilter), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Status Filter
            statusFilterSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            statusFilterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusFilterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusFilterSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            // Date Filter Button
            dateFilterButton.topAnchor.constraint(equalTo: statusFilterSegmentedControl.bottomAnchor, constant: 8),
            dateFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateFilterButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Clear Date Button
            clearDateButton.centerYAnchor.constraint(equalTo: dateFilterButton.centerYAnchor),
            clearDateButton.leadingAnchor.constraint(equalTo: dateFilterButton.trailingAnchor, constant: 8),
            clearDateButton.widthAnchor.constraint(equalToConstant: 32),
            clearDateButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Result Count Label
            resultCountLabel.centerYAnchor.constraint(equalTo: dateFilterButton.centerYAnchor),
            resultCountLabel.leadingAnchor.constraint(equalTo: clearDateButton.trailingAnchor, constant: 12),
            resultCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: dateFilterButton.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty State Label
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .appPrimary
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DonationHistoryCell.self, forCellReuseIdentifier: DonationHistoryCell.identifier)
    }
    
    // MARK: - Filter Actions
    @objc private func statusFilterChanged() {
        currentStatusFilter = DonationFilter.allCases[statusFilterSegmentedControl.selectedSegmentIndex]
        applyFilters()
    }
    
    @objc private func showDateRangePicker() {
        let dateRangeVC = DateRangePickerViewController()
        dateRangeVC.startDate = startDate
        dateRangeVC.endDate = endDate
        dateRangeVC.delegate = self
        
        let navController = UINavigationController(rootViewController: dateRangeVC)
        navController.navigationBar.tintColor = .appPrimary
        present(navController, animated: true)
    }
    
    @objc private func clearDateFilter() {
        startDate = nil
        endDate = nil
        dateFilterButton.setTitle("📅 Select Date Range", for: .normal)
        clearDateButton.isHidden = true
        applyFilters()
    }
    
    private func applyFilters() {
        var filtered = allDonations
        
        // Apply status filter
        switch currentStatusFilter {
        case .all:
            break
        case .pending:
            filtered = filtered.filter { $0.status?.lowercased() == "pending" }
        case .completed:
            filtered = filtered.filter { $0.status?.lowercased() == "completed" }
        case .collected:
            filtered = filtered.filter { $0.status?.lowercased() == "collected" }
        case .cancelled:
            filtered = filtered.filter { $0.status?.lowercased() == "cancelled" }
        }
        
        // Apply date range filter
        if let start = startDate, let end = endDate {
            filtered = filtered.filter { donation in
                guard let dateString = donation.date else { return false }
                guard let date = parseDate(dateString) else { return false }
                return date >= start && date <= end
            }
        }
        
        filteredDonations = filtered
        
        updateResultCount()
        updateEmptyState()
        tableView.reloadData()
        
        let dateInfo = startDate != nil ? "with date range" : "no date filter"
        print("🔍 Filters - Status: \(currentStatusFilter.displayName), \(dateInfo) - Showing \(filteredDonations.count) of \(allDonations.count)")
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func updateResultCount() {
        if allDonations.isEmpty {
            resultCountLabel.text = ""
        } else if currentStatusFilter == .all && startDate == nil {
            resultCountLabel.text = "📊 \(allDonations.count) donation\(allDonations.count == 1 ? "" : "s")"
        } else {
            resultCountLabel.text = "📊 \(filteredDonations.count) of \(allDonations.count)"
        }
    }
    
    // MARK: - Data Loading
    private func loadDonations() {
        showLoading(true)
        
        Task {
            do {
                if testMode {
                    print("🧪 TEST MODE: Loading sample donations")
                    allDonations = try await SupabaseService.shared.fetchAllDonations()
                } else {
                    guard let userId = UserDefaults.standard.string(forKey: "userId") else {
                        throw NSError(domain: "", code: 401, userInfo: [
                            NSLocalizedDescriptionKey: "Please log in to view your donations"
                        ])
                    }
                    
                    print("👤 Loading donations for user: \(userId)")
                    allDonations = try await SupabaseService.shared.fetchDonationHistory(forUserId: userId)
                }
                
                print("📦 Loaded \(allDonations.count) donations")
                
                await MainActor.run {
                    showLoading(false)
                    applyFilters()
                }
            } catch {
                print("❌ Error: \(error.localizedDescription)")
                
                await MainActor.run {
                    showLoading(false)
                    showError(error)
                }
            }
        }
    }
    
    @objc private func refreshData() {
        Task {
            do {
                if testMode {
                    allDonations = try await SupabaseService.shared.fetchAllDonations()
                } else {
                    guard let userId = UserDefaults.standard.string(forKey: "userId") else {
                        throw NSError(domain: "", code: 401, userInfo: [
                            NSLocalizedDescriptionKey: "Please log in"
                        ])
                    }
                    allDonations = try await SupabaseService.shared.fetchDonationHistory(forUserId: userId)
                }
                
                await MainActor.run {
                    tableView.refreshControl?.endRefreshing()
                    applyFilters()
                }
            } catch {
                await MainActor.run {
                    tableView.refreshControl?.endRefreshing()
                    showError(error)
                }
            }
        }
    }
    
    // MARK: - UI Updates
    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
            tableView.isHidden = true
            emptyStateLabel.isHidden = true
            statusFilterSegmentedControl.isHidden = true
            dateFilterButton.isHidden = true
            clearDateButton.isHidden = true
            resultCountLabel.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            tableView.isHidden = false
            statusFilterSegmentedControl.isHidden = false
            dateFilterButton.isHidden = false
            resultCountLabel.isHidden = false
            clearDateButton.isHidden = (startDate == nil)
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = filteredDonations.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        
        if isEmpty {
            if currentStatusFilter == .all && startDate == nil {
                emptyStateLabel.text = "No donations yet"
            } else if currentStatusFilter != .all && startDate == nil {
                emptyStateLabel.text = "No \(currentStatusFilter.displayName.lowercased()) donations"
            } else if currentStatusFilter == .all && startDate != nil {
                emptyStateLabel.text = "No donations in selected date range"
            } else {
                emptyStateLabel.text = "No \(currentStatusFilter.displayName.lowercased()) donations in selected date range"
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error Loading Donations",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadDonations()
        })
        present(alert, animated: true)
    }
}

// MARK: - DateRangePickerDelegate
extension DonationHistoryViewController: DateRangePickerDelegate {
    func didSelectDateRange(start: Date, end: Date) {
        startDate = start
        endDate = end
        
        let startStr = formatDate(start)
        let endStr = formatDate(end)
        dateFilterButton.setTitle("📅 \(startStr) - \(endStr)", for: .normal)
        clearDateButton.isHidden = false
        
        applyFilters()
    }
}

// MARK: - UITableViewDataSource
extension DonationHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDonations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DonationHistoryCell.identifier,
            for: indexPath
        ) as? DonationHistoryCell else {
            return UITableViewCell()
        }
        
        let donation = filteredDonations[indexPath.row]
        cell.configure(with: donation)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DonationHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let donation = filteredDonations[indexPath.row]
        print("📍 Selected donation ID: \(donation.donationid)")
        
        let detailVC = DonationDetailViewController()
        detailVC.donationId = donation.donationid
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
