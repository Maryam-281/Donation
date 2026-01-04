//import UIKit
//import Supabase
//
//class NewChatViewController: UIViewController {
//    
//    // MARK: - Properties
//    public let currentUserId: UUID
//    private var isLoading = false
//    
//    // MARK: - UI Components
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Start New Chat"
//        label.font = .systemFont(ofSize: 24, weight: .bold)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let instructionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Enter the user's UUID to start a conversation"
//        label.font = .systemFont(ofSize: 14)
//        label.textColor = .secondaryLabel
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let uuidTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "User UUID"
//        textField.borderStyle = .roundedRect
//        textField.backgroundColor = .systemGray6
//        textField.autocapitalizationType = .none
//        textField.autocorrectionType = .no
//        textField.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//    
//    private let userInfoContainer: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemGray6
//        view.layer.cornerRadius = 12
//        view.isHidden = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let userNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 18, weight: .semibold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let userEmailLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14)
//        label.textColor = .secondaryLabel
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let searchButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Find User", for: .normal)
//        button.backgroundColor = .systemBlue
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
//        button.layer.cornerRadius = 12
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private let startChatButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Start Chat", for: .normal)
//        button.backgroundColor = .systemGreen
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
//        button.layer.cornerRadius = 12
//        button.isHidden = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private let activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView(style: .medium)
//        indicator.hidesWhenStopped = true
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        return indicator
//    }()
//    
//    private var foundUser: User?
//    
//    // MARK: - Initialization
//    init(currentUserId: UUID) {
//        self.currentUserId = currentUserId
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupActions()
//        
//        title = "New Chat"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .cancel,
//            target: self,
//            action: #selector(cancelTapped)
//        )
//    }
//    
//    // MARK: - Setup
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        
//        // Add subviews
//        view.addSubview(titleLabel)
//        view.addSubview(instructionLabel)
//        view.addSubview(uuidTextField)
//        view.addSubview(searchButton)
//        view.addSubview(userInfoContainer)
//        view.addSubview(startChatButton)
//        view.addSubview(activityIndicator)
//        
//        userInfoContainer.addSubview(userNameLabel)
//        userInfoContainer.addSubview(userEmailLabel)
//        
//        NSLayoutConstraint.activate([
//            // Title
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            // Instruction
//            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            // UUID TextField
//            uuidTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 32),
//            uuidTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            uuidTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            uuidTextField.heightAnchor.constraint(equalToConstant: 50),
//            
//            // Search Button
//            searchButton.topAnchor.constraint(equalTo: uuidTextField.bottomAnchor, constant: 16),
//            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            searchButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            // User Info Container
//            userInfoContainer.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 24),
//            userInfoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            userInfoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            userInfoContainer.heightAnchor.constraint(equalToConstant: 80),
//            
//            // User Name
//            userNameLabel.topAnchor.constraint(equalTo: userInfoContainer.topAnchor, constant: 16),
//            userNameLabel.leadingAnchor.constraint(equalTo: userInfoContainer.leadingAnchor, constant: 16),
//            userNameLabel.trailingAnchor.constraint(equalTo: userInfoContainer.trailingAnchor, constant: -16),
//            
//            // User Email
//            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
//            userEmailLabel.leadingAnchor.constraint(equalTo: userInfoContainer.leadingAnchor, constant: 16),
//            userEmailLabel.trailingAnchor.constraint(equalTo: userInfoContainer.trailingAnchor, constant: -16),
//            
//            // Start Chat Button
//            startChatButton.topAnchor.constraint(equalTo: userInfoContainer.bottomAnchor, constant: 16),
//            startChatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            startChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            startChatButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            // Activity Indicator
//            activityIndicator.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor)
//        ])
//    }
//    
//    private func setupActions() {
//        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
//        startChatButton.addTarget(self, action: #selector(startChatButtonTapped), for: .touchUpInside)
//        uuidTextField.delegate = self
//    }
//    
//    // MARK: - Actions
//    @objc private func cancelTapped() {
//        dismiss(animated: true)
//    }
//    
//    @objc private func searchButtonTapped() {
//        guard let uuidString = uuidTextField.text?.trimmingCharacters(in: .whitespaces),
//              !uuidString.isEmpty else {
//            showAlert(title: "Invalid Input", message: "Please enter a UUID")
//            return
//        }
//        
//        guard let userId = UUID(uuidString: uuidString) else {
//            showAlert(title: "Invalid UUID", message: "The UUID format is invalid. Please check and try again.")
//            return
//        }
//        
//        if userId == currentUserId {
//            showAlert(title: "Invalid User", message: "You cannot start a chat with yourself.")
//            return
//        }
//        
//        searchForUser(userId: userId)
//    }
//    
//    @objc private func startChatButtonTapped() {
//        guard let user = foundUser else { return }
//        createOrOpenChat(with: user)
//    }
//    
//    // MARK: - User Search
//    private func searchForUser(userId: UUID) {
//        setLoading(true)
//        
//        Task {
//            do {
//                let user = try await findUser(byId: userId)
//                
//                await MainActor.run {
//                    setLoading(false)
//                    displayUserInfo(user)
//                }
//            } catch {
//                await MainActor.run {
//                    setLoading(false)
//                    showAlert(title: "User Not Found", message: "No user found with this UUID. Please check and try again.")
//                    hideUserInfo()
//                }
//            }
//        }
//    }
//    
//    private func findUser(byId userId: UUID) async throws -> User {
//        let response: [User] = try await SupabaseService.shared.client
//            .from("User")
//            .select("id, first_name, last_name, email, birth_date, phone_number, profile_image_url, is_active, created_at")
//            .eq("id", value: userId.uuidString)
//            .execute()
//            .value
//        
//        guard let user = response.first else {
//            throw NSError(domain: "UserNotFound", code: 404, userInfo: nil)
//        }
//        
//        return user
//    }
//    
//    // MARK: - Chat Creation
//    private func createOrOpenChat(with user: User) {
//        setLoading(true)
//        
//        Task {
//            do {
//                let chatId = try await getOrCreateChat(with: user.id)
//                
//                await MainActor.run {
//                    setLoading(false)
//                    openChat(chatId: chatId, otherUser: user)
//                }
//            } catch {
//                await MainActor.run {
//                    setLoading(false)
//                    showAlert(title: "Error", message: "Failed to create chat: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    private func getOrCreateChat(with otherUserId: UUID) async throws -> UUID {
//        // Check if chat already exists between these two users
//        struct ChatParticipantResponse: Codable {
//            let chat_id: UUID
//            let user_id: UUID
//        }
//        
//        // Get all chats for current user
//        let currentUserChats: [ChatParticipantResponse] = try await SupabaseService.shared.client
//            .from("chat_participants")
//            .select("chat_id, user_id")
//            .eq("user_id", value: currentUserId.uuidString)
//            .execute()
//            .value
//        
//        // Check each chat to see if other user is also a participant
//        for chatParticipant in currentUserChats {
//            let participants: [ChatParticipantResponse] = try await SupabaseService.shared.client
//                .from("chat_participants")
//                .select("user_id")
//                .eq("chat_id", value: chatParticipant.chat_id.uuidString)
//                .execute()
//                .value
//            
//            if participants.contains(where: { $0.user_id == otherUserId }) {
//                print("✅ Found existing chat: \(chatParticipant.chat_id)")
//                return chatParticipant.chat_id
//            }
//        }
//        
//        // Create new chat if none exists
//        print("📝 Creating new chat...")
//        let chatId = UUID()
//        
//        struct ChatInsert: Encodable {
//            let id: String
//        }
//        
//        // Insert into chats table
//        try await SupabaseService.shared.client
//            .from("chats")
//            .insert(ChatInsert(id: chatId.uuidString))
//            .execute()
//        
//        // Insert participants
//        struct ParticipantInsert: Encodable {
//            let chat_id: String
//            let user_id: String
//        }
//        
//        let participants = [
//            ParticipantInsert(chat_id: chatId.uuidString, user_id: currentUserId.uuidString),
//            ParticipantInsert(chat_id: chatId.uuidString, user_id: otherUserId.uuidString)
//        ]
//        
//        try await SupabaseService.shared.client
//            .from("chat_participants")
//            .insert(participants)
//            .execute()
//        
//        print("✅ Chat created: \(chatId)")
//        return chatId
//    }
//    
//    private func openChat(chatId: UUID, otherUser: User) {
//        // Dismiss and let ChatListViewController handle the navigation
//        if let presentingNav = presentingViewController as? UINavigationController {
//            dismiss(animated: true) {
//                // Find the ChatListViewController
//                if let chatListVC = presentingNav.viewControllers.first as? ChatListViewController {
//                    chatListVC.openChatWithId(chatId: chatId, otherUser: otherUser)
//                }
//            }
//        }
//    }
//    
//    // MARK: - UI Helpers
//    private func displayUserInfo(_ user: User) {
//        foundUser = user
//        userNameLabel.text = user.fullName
//        userEmailLabel.text = user.email
//        
//        UIView.animate(withDuration: 0.3) {
//            self.userInfoContainer.isHidden = false
//            self.startChatButton.isHidden = false
//        }
//    }
//
//    
//    private func hideUserInfo() {
//        foundUser = nil
//        userInfoContainer.isHidden = true
//        startChatButton.isHidden = true
//    }
//    
//    private func setLoading(_ loading: Bool) {
//        isLoading = loading
//        
//        if loading {
//            activityIndicator.startAnimating()
//            searchButton.setTitle("", for: .normal)
//            searchButton.isEnabled = false
//            startChatButton.isEnabled = false
//        } else {
//            activityIndicator.stopAnimating()
//            searchButton.setTitle("Find User", for: .normal)
//            searchButton.isEnabled = true
//            startChatButton.isEnabled = true
//        }
//    }
//    
//    private func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
//
//// MARK: - UITextFieldDelegate
//extension NewChatViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        searchButtonTapped()
//        return true
//    }
//}
