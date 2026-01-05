

import UIKit

class ReportsListViewController: UIViewController {
    
    // MARK: - UI Components
    private let segmentedControl: UISegmentedControl = {
        let items = ["All", "Pending", "Reviewed", "Resolved"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No reports found"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var allReports: [Report] = []
    private var filteredReports: [Report] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadReports()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshReports()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(loadingView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.identifier)
        tableView.refreshControl = refreshControl
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(refreshReports), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 200),
            emptyStateView.heightAnchor.constraint(equalToConstant: 200),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Reports"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGroupedBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Data Loading
    private func loadReports() {
        loadingView.startAnimating()
        emptyStateView.isHidden = true
        
        Task {
            do {
                allReports = try await SupabaseManager.shared.fetchReports()
                await MainActor.run {
                    loadingView.stopAnimating()
                    filterReports()
                }
            } catch {
                await MainActor.run {
                    loadingView.stopAnimating()
                    showError(error)
                }
            }
        }
    }
    
    @objc private func refreshReports() {
        Task {
            do {
                allReports = try await SupabaseManager.shared.fetchReports()
                await MainActor.run {
                    refreshControl.endRefreshing()
                    filterReports()
                }
            } catch {
                await MainActor.run {
                    refreshControl.endRefreshing()
                    showError(error)
                }
            }
        }
    }
    
    private func filterReports() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: // All
            filteredReports = allReports
        case 1: // Pending
            filteredReports = allReports.filter { $0.reportStatus == .pending }
        case 2: // Reviewed
            filteredReports = allReports.filter { $0.reportStatus == .reviewed }
        case 3: // Resolved
            filteredReports = allReports.filter { $0.reportStatus == .resolved }
        default:
            filteredReports = allReports
        }
        
        updateEmptyState()
        tableView.reloadData()
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !filteredReports.isEmpty
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadReports()
        })
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func segmentChanged() {
        filterReports()
    }
}

// MARK: - UITableViewDelegate & DataSource
extension ReportsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as? ReportTableViewCell else {
            return UITableViewCell()
        }
        
        let report = filteredReports[indexPath.row]
        cell.configure(with: report)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = filteredReports[indexPath.row]
        let detailVC = ReportDetailViewController(report: report)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let report = filteredReports[indexPath.row]
        
        // Don't show actions for resolved or dismissed reports
        if report.reportStatus == .resolved || report.reportStatus == .dismissed {
            return nil
        }
        
        let resolveAction = UIContextualAction(style: .normal, title: "Resolve") { [weak self] _, _, completion in
            self?.updateReportStatus(at: indexPath, newStatus: .resolved)
            completion(true)
        }
        resolveAction.backgroundColor = .systemGreen
        resolveAction.image = UIImage(systemName: "checkmark.circle.fill")
        
        let dismissAction = UIContextualAction(style: .destructive, title: "Dismiss") { [weak self] _, _, completion in
            self?.updateReportStatus(at: indexPath, newStatus: .dismissed)
            completion(true)
        }
        dismissAction.image = UIImage(systemName: "xmark.circle.fill")
        
        return UISwipeActionsConfiguration(actions: [dismissAction, resolveAction])
    }
    
    private func updateReportStatus(at indexPath: IndexPath, newStatus: Report.ReportStatus) {
        let report = filteredReports[indexPath.row]
        
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
                    
                    // Update in main array
                    if let mainIndex = self.allReports.firstIndex(where: { $0.id == report.id }) {
                        self.allReports[mainIndex] = updatedReport
                    }
                    
                    // Re-filter
                    self.filterReports()
                }
            } catch {
                await MainActor.run {
                    loadingAlert.dismiss(animated: true)
                    self.showError(error)
                }
            }
        }
    }
}

// MARK: - ReportDetailDelegate
extension ReportsListViewController: ReportDetailDelegate {
    func didUpdateReport(_ report: Report) {
        // Refresh from server
        refreshReports()
    }
}
