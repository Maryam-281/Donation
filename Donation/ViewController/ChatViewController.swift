import UIKit

class ChatViewController: UIViewController {
    
    // These will be connected from Storyboard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputBottomConstraint: NSLayoutConstraint!
    
    // Set by previous view controller
    var chatId: UUID!
    var currentUserId: UUID!
    
    private let messagingService = MessagingService()
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chat"
        
        // Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.separatorStyle = .none
        
        // Setup text field
        messageTextField.delegate = self
        messageTextField.placeholder = "Type a message..."
        
        // Setup send button
        sendButton.setTitle("Send", for: .normal)
        
        // Setup keyboard
        setupKeyboard()
        
        // Setup messaging service
        messagingService.onMessagesUpdated = { [weak self] messages in
            self?.messages = messages
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }
        
        // Load messages
        loadMessages()
        
        // Subscribe to real-time updates
        messagingService.subscribeToMessages(chatId: chatId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messagingService.unsubscribe()
    }
    
    private func loadMessages() {
        Task {
            try? await messagingService.fetchMessages(chatId: chatId)
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return }
        
        messageTextField.text = ""
        
        Task {
            do {
                try await messagingService.sendMessage(
                    text: text,
                    chatId: chatId,
                    senderId: currentUserId
                )
            } catch {
                await MainActor.run {
                    showError(error)
                }
            }
        }
    }
    
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Dismiss keyboard when tapping outside
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        inputBottomConstraint.constant = keyboardHeight - view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        inputBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Table View
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let message = messages[indexPath.row]
        
        let isFromCurrentUser = message.senderId == currentUserId
        
        // Configure cell
        cell.textLabel?.text = message.text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = isFromCurrentUser ? .right : .left
        
        // Simple styling
        if isFromCurrentUser {
            cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        } else {
            cell.backgroundColor = UIColor.systemGray6
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - Text Field
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped(sendButton)
        return true
    }
}
