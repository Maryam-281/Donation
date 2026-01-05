import UIKit

class ChatsListViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Search chats"
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var allChats: [(chatId: UUID, otherUser: User, lastMessage: String)] = []
    private var filteredChats: [(chatId: UUID, otherUser: User, lastMessage: String)] = []
    
    private var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
        view.backgroundColor = .systemBackground
        
        setupSearchController()
        setupTableView()
        loadTestChats()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadTestChats() {
        // Create multiple test users for demonstration
        let janeUser = User(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
            firstName: "Jane",
            lastName: "Smith",
            email: "jane@test.com",
            birthDate: nil,
            phoneNumber: nil,
            profileImageUrl: nil,
            isActive: true,
            createdAt: nil
        )
        
        allChats = [
            (
                chatId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
                otherUser: janeUser,
                lastMessage: "I am doing great, thanks!"
            )
        ]
        
        filteredChats = allChats
        tableView.reloadData()
        print("✅ Loaded \(allChats.count) chats")
    }
    
    private func filterChats(with searchText: String) {
        if searchText.isEmpty {
            filteredChats = allChats
        } else {
            filteredChats = allChats.filter { chat in
                chat.otherUser.fullName.lowercased().contains(searchText.lowercased()) ||
                chat.lastMessage.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension ChatsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filterChats(with: searchText)
    }
}

// MARK: - UISearchControllerDelegate
extension ChatsListViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        filteredChats = allChats
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredChats.count : allChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        let chats = isSearching ? filteredChats : allChats
        let chat = chats[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = chat.otherUser.fullName
        config.secondaryText = chat.lastMessage
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chats = isSearching ? filteredChats : allChats
        let chat = chats[indexPath.row]
        let currentUserId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!
        
        let chatVC = ChatViewController()
        chatVC.chatId = chat.chatId
        chatVC.currentUserId = currentUserId
        chatVC.otherUser = chat.otherUser
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
