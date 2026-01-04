import UIKit

class ChatViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.backgroundColor = .systemBackground
        tv.keyboardDismissMode = .interactive
        return tv
    }()
    
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type a message..."
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.returnKeyType = .send
        tf.enablesReturnKeyAutomatically = true
        return tf
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var inputBottomConstraint: NSLayoutConstraint!
    
    var chatId: UUID!
    var currentUserId: UUID!
    var otherUser: User!
    
    private let messagingService = MessagingService()
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("🔵 ChatViewController loaded")
        
        view.backgroundColor = .systemBackground
        title = otherUser?.fullName ?? "Chat"
        
        // Back button will work automatically with navigation controller
        // No need to add a custom one
        
        setupUI()
        setupTableView()
        setupKeyboard()
        setupMessaging()
        
        loadMessages()
        messagingService.subscribeToMessages(chatId: chatId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Activate text field after a short delay to ensure view is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.messageTextField.becomeFirstResponder()
            print("🔵 Text field became first responder: \(self.messageTextField.isFirstResponder)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messagingService.unsubscribe()
        view.endEditing(true)
    }
    
    private func setupUI() {
        let separatorLine = UIView()
        separatorLine.backgroundColor = .separator
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(separatorLine)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(messageTextField)
        inputContainerView.addSubview(sendButton)
        
        // Anchor to the BOTTOM of safe area, not keyboard layout guide
        inputBottomConstraint = inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: separatorLine.topAnchor),
            
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputBottomConstraint,
            inputContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            messageTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 12),
            messageTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        messageTextField.delegate = self
        
        messageTextField.isUserInteractionEnabled = true
        inputContainerView.isUserInteractionEnabled = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
    }
    
    private func setupMessaging() {
        messagingService.onMessagesUpdated = { [weak self] messages in
            print("🔵 Messages updated: \(messages.count) messages")
            self?.messages = messages
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }
    }
    
    private func loadMessages() {
        print("🔵 Loading messages for chat: \(chatId?.uuidString ?? "nil")")
        Task {
            do {
                try await messagingService.fetchMessages(chatId: chatId)
                print("🔵 Messages loaded successfully")
            } catch {
                print("❌ Error loading messages: \(error)")
                await MainActor.run {
                    showError(error)
                }
            }
        }
    }
    
    @objc private func sendButtonTapped() {
        print("🔵 Send button tapped")
        print("🔵 Text field text: '\(messageTextField.text ?? "nil")'")
        
        guard let text = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            print("⚠️ Text is empty")
            // Show a brief alert
            let alert = UIAlertController(title: nil, message: "Please enter a message", preferredStyle: .alert)
            present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true)
            }
            return
        }
        
        print("🔵 Sending message: \(text)")
        messageTextField.text = ""
        
        Task {
            do {
                try await messagingService.sendMessage(
                    text: text,
                    chatId: chatId,
                    senderId: currentUserId,
                    receiverId: otherUser.id
                )
                print("✅ Message sent successfully")
            } catch {
                print("❌ Error sending message: \(error)")
                await MainActor.run {
                    showError(error)
                }
            }
        }
    }
    
    @objc private func closeTapped() {
        print("🔵 Close button tapped")
        // Create an alert to confirm
        let alert = UIAlertController(
            title: "Exit Chat",
            message: "Are you sure you want to exit?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive) { _ in
            // Exit the app (for testing purposes only)
            exit(0)
        })
        present(alert, animated: true)
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        print("🔵 Keyboard will show - height: \(keyboardFrame.height)")
        
        // Adjust for safe area
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        
        inputBottomConstraint.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        // Scroll to bottom after keyboard appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        print("🔵 Keyboard will hide")
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        let isFromCurrentUser = message.senderId == currentUserId
        
        cell.configure(with: message, isCurrentUser: isFromCurrentUser)
        
        return cell
    }
}

// MARK: - Text Field
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("🔵 Text field began editing")
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("🔵 Text changed: \(textField.text ?? "")")
    }
}
