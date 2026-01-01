import UIKit

class ChatListViewController: UIViewController {
    
    // This will be connected from Storyboard
    @IBOutlet weak var tableView: UITableView!
    
    private let chatService = ChatService()
    private var chats: [Chat] = []
    
    // For testing - we'll replace this with real auth later
    private var currentUserId: UUID = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Messages"
        
        // Add "New Chat" button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(newChatTapped)
        )
        
        // Setup table view
        setupTableView()
        
        // Load chats
        loadChats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadChats()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatCell")
    }
    
    private func loadChats() {
        Task {
            do {
                let fetchedChats = try await chatService.getUserChats(userId: currentUserId)
                self.chats = fetchedChats
                
                await MainActor.run {
                    self.tableView.reloadData()
                }
            } catch {
                await MainActor.run {
                    showError(error)
                }
            }
        }
    }
    
    @objc private func newChatTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newChatVC = storyboard.instantiateViewController(
            withIdentifier: "NewChatViewController"
        ) as? NewChatViewController else { return }
        
        newChatVC.currentUserId = currentUserId
        navigationController?.pushViewController(newChatVC, animated: true)
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
}

// MARK: - Table View
extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        let chat = chats[indexPath.row]
        
        // Simple display - we'll improve this later
        cell.textLabel?.text = "Chat \(chat.id.uuidString.prefix(8))"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chat = chats[indexPath.row]
        openChat(chat)
    }
    
    private func openChat(_ chat: Chat) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let chatVC = storyboard.instantiateViewController(
            withIdentifier: "ChatViewController"
        ) as? ChatViewController else { return }
        
        chatVC.chatId = chat.id
        chatVC.currentUserId = currentUserId
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
