// DonationHistoryViewController.swift

import UIKit

class DonationHistoryViewController: UIViewController {
    
    // MARK: - UI Components (Created Programmatically)
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
        indicator.color = .systemGray
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No donations yet"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    private var donations: [DonationHistory] = []
    private var userId: UUID?  // Changed from userEmail to userId
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In viewDidLoad
        Task {
            try? await SupabaseService.shared.listAllTables()
        }
        
        #if DEBUG
        setupTestUser() // Only runs in debug builds
        #endif
        
        setupNavigationBar()
        setupUI()
        setupTableView()
        loadDonations()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Donation History"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Optional: Add refresh button
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshData)
        )
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Table View - fills entire view
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Activity Indicator - centered
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty State Label - centered
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        // Add pull-to-refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cell
        tableView.register(
            DonationHistoryCell.self,
            forCellReuseIdentifier: DonationHistoryCell.identifier
        )
    }
    
    // MARK: - Data Loading
    private func loadDonations() {
        showLoading(true)
        
        Task {
            do {
                guard let userIdString = UserDefaults.standard.string(forKey: "userId"),
                      let uuid = UUID(uuidString: userIdString) else {
                    throw NSError(domain: "DonationHistory", code: 401,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid user ID"])
                }
                
                userId = uuid
                
                // TEST: Run raw query test
                try await SupabaseService.shared.testRawQuery(userId: uuid.uuidString.lowercased())
                
                print("🔍 Fetching donations for userId: '\(uuid.uuidString)'")
                
                donations = try await SupabaseService.shared.fetchDonationHistory(forUserId: uuid)
                
                print("📦 Received \(donations.count) donations")
                
                await MainActor.run {
                    showLoading(false)
                    updateEmptyState()
                    tableView.reloadData()
                    print("✅ UI Updated - isEmpty: \(donations.isEmpty)")
                }
            } catch {
                print("❌ Error: \(error)")
                
                await MainActor.run {
                    showLoading(false)
                    showError(error)
                }
            }
        }
    }
    
    @objc private func refreshData() {
        guard let userId = userId else {
            print("⚠️ No user ID available for refresh")
            tableView.refreshControl?.endRefreshing()
            return
        }
        
        Task {
            do {
                donations = try await SupabaseService.shared.fetchDonationHistory(forUserId: userId)
                
                await MainActor.run {
                    tableView.refreshControl?.endRefreshing()
                    updateEmptyState()
                    tableView.reloadData()
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
        } else {
            activityIndicator.stopAnimating()
            tableView.isHidden = false
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = donations.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
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

// MARK: - UITableViewDataSource
extension DonationHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DonationHistoryCell.identifier,
            for: indexPath
        ) as? DonationHistoryCell else {
            return UITableViewCell()
        }
        
        let donation = donations[indexPath.row]
        cell.configure(with: donation)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DonationHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let donation = donations[indexPath.row]
        
        // Navigate to detail view
        let detailVC = DonationDetailViewController()
        detailVC.donationId = donation.donationid
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Testing Helper (Remove when login is implemented)
    private func setupTestUser() {
        #if DEBUG
        // Get UUID from your Supabase User table
        let testUserId = "83e4f185-b461-4172-b3d1-8860d2ba5648" // Replace with actual UUID from database
        UserDefaults.standard.set(testUserId, forKey: "userId")
        print("🧪 Test user ID set: \(testUserId)")
        #endif
    }
}
