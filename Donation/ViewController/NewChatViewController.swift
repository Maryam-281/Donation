import UIKit

class NewChatViewController: UIViewController {
    
    // Will be connected from Storyboard
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var currentUserId: UUID!
    private let chatService = ChatService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Chat"
        
        // Setup UI
        userIdTextField.placeholder = "Enter recipient's User ID"
        userIdTextField.borderStyle = .roundedRect
        
        createButton.setTitle("Create Chat", for: .normal)
        createButton.backgroundColor = .systemBlue
        createButton.setTitleColor(.white, for: .normal)
        createButton.layer.cornerRadius = 8
        
        instructionLabel.text = "For testing: Use any UUID format\nExample: 550e8400-e29b-41d4-a716-446655440000"
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = .center
        instructionLabel.font = .systemFont(ofSize: 12)
        instructionLabel.textColor = .secondaryLabel
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        guard let userIdString = userIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !userIdString.isEmpty else {
            showAlert(message: "Please enter a user ID")
            return
        }
        
        guard let recipientId = UUID(uuidString: userIdString) else {
            showAlert(message: "Invalid UUID format")
            return
        }
        
        createChat(with: recipientId)
    }
    
    private func createChat(with recipientId: UUID) {
        // Show loading
        createButton.isEnabled = false
        createButton.setTitle("Creating...", for: .normal)
        
        Task {
            do {
                let chatId = try await chatService.createChat(
                    participantIds: [currentUserId, recipientId]
                )
                
                await MainActor.run {
                    // Navigate to the new chat
                    openChat(chatId: chatId)
                }
            } catch {
                await MainActor.run {
                    createButton.isEnabled = true
                    createButton.setTitle("Create Chat", for: .normal)
                    showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func openChat(chatId: UUID) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let chatVC = storyboard.instantiateViewController(
            withIdentifier: "ChatViewController"
        ) as? ChatViewController else { return }
        
        chatVC.chatId = chatId
        chatVC.currentUserId = currentUserId
        
        // Pop this screen and push chat screen
        var viewControllers = navigationController?.viewControllers ?? []
        viewControllers.removeLast() // Remove NewChatViewController
        viewControllers.append(chatVC) // Add ChatViewController
        navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
