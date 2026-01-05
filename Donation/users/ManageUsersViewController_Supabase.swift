//
//  ManageUsersViewController.swift
//  Donation
//
//  Created by Claude
//

import UIKit

class ManageUsersViewController: UIViewController {
    
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search users..."
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add New User", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "89AAC5")
        button.layer.cornerRadius = 28
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.shadowColor = UIColor(hex: "89AAC5")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        imageView.image = UIImage(systemName: "person.3.fill")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No users found"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private var isSearching = false
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUsers()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(emptyStateView)
        view.addSubview(loadingView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.refreshControl = refreshControl
        
        searchBar.delegate = self
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 56),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
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
        title = "Manage Users"
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
    private func loadUsers() {
        loadingView.startAnimating()
        emptyStateView.isHidden = true
        
        Task {
            do {
                users = try await SupabaseManager.shared.fetchUsers()
                await MainActor.run {
                    loadingView.stopAnimating()
                    updateEmptyState()
                    tableView.reloadData()
                }
            } catch {
                await MainActor.run {
                    loadingView.stopAnimating()
                    showError(error)
                }
            }
        }
    }
    
    @objc private func refreshUsers() {
        Task {
            do {
                users = try await SupabaseManager.shared.fetchUsers()
                await MainActor.run {
                    refreshControl.endRefreshing()
                    if isSearching, let searchText = searchBar.text, !searchText.isEmpty {
                        searchUsers(query: searchText)
                    } else {
                        updateEmptyState()
                        tableView.reloadData()
                    }
                }
            } catch {
                await MainActor.run {
                    refreshControl.endRefreshing()
                    showError(error)
                }
            }
        }
    }
    
    private func searchUsers(query: String) {
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                // Search locally first for instant results
                filteredUsers = users.filter { user in
                    user.fullName.lowercased().contains(query.lowercased()) ||
                    user.email.lowercased().contains(query.lowercased())
                }
                
                await MainActor.run {
                    updateEmptyState()
                    tableView.reloadData()
                }
                
                // Then fetch from Supabase for accurate results
                let searchResults = try await SupabaseManager.shared.searchUsers(query: query)
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    filteredUsers = searchResults
                    updateEmptyState()
                    tableView.reloadData()
                }
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    showError(error)
                }
            }
        }
    }
    
    private func updateEmptyState() {
        let displayUsers = isSearching ? filteredUsers : users
        emptyStateView.isHidden = !displayUsers.isEmpty
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadUsers()
        })
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let addUserVC = AddUserViewController()
        addUserVC.delegate = self
        let navController = UINavigationController(rootViewController: addUserVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension ManageUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.configure(with: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        let detailVC = UserDetailViewController(user: user)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteUser(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            self?.editUser(at: indexPath)
            completion(true)
        }
        editAction.backgroundColor = UIColor(hex: "89AAC5")
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func deleteUser(at indexPath: IndexPath) {
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        let alert = UIAlertController(title: "Delete User", message: "Are you sure you want to delete \(user.fullName)?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // Show loading
            let loadingAlert = UIAlertController(title: nil, message: "Deleting...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(style: .medium)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingAlert.view.addSubview(loadingIndicator)
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingAlert.view.centerXAnchor).isActive = true
            loadingIndicator.bottomAnchor.constraint(equalTo: loadingAlert.view.bottomAnchor, constant: -20).isActive = true
            loadingIndicator.startAnimating()
            self.present(loadingAlert, animated: true)
            
            Task {
                do {
                    try await SupabaseManager.shared.deleteUser(id: user.id)
                    
                    await MainActor.run {
                        loadingAlert.dismiss(animated: true)
                        
                        // Remove from local arrays
                        if self.isSearching {
                            self.filteredUsers.remove(at: indexPath.row)
                            if let mainIndex = self.users.firstIndex(where: { $0.id == user.id }) {
                                self.users.remove(at: mainIndex)
                            }
                        } else {
                            self.users.remove(at: indexPath.row)
                        }
                        
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.updateEmptyState()
                    }
                } catch {
                    await MainActor.run {
                        loadingAlert.dismiss(animated: true)
                        self.showError(error)
                    }
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    private func editUser(at indexPath: IndexPath) {
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        let editVC = AddUserViewController(user: user)
        editVC.delegate = self
        let navController = UINavigationController(rootViewController: editVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension ManageUsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredUsers = []
            searchTask?.cancel()
        } else {
            isSearching = true
            searchUsers(query: searchText)
        }
        
        updateEmptyState()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredUsers = []
        searchTask?.cancel()
        updateEmptyState()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - AddUserDelegate
extension ManageUsersViewController: AddUserDelegate {
    func didAddUser(_ user: User) {
        // Refresh from server to get the latest data
        refreshUsers()
    }
}
