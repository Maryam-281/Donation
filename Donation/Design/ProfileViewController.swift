import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfile()
    }

    private func loadProfile() {
        guard let user = Auth.auth().currentUser else {
            nameLabel.text = "Name: -"
            emailLabel.text = "Email: -"
            roleLabel.text = "Role: -"
            return
        }

        // Email: UserDefaults أول بعدين Firebase
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail")
        let email = savedEmail ?? user.email ?? "-"
        emailLabel.text = "Email: \(email)"

        // Name: UserDefaults أول بعدين Firebase displayName
        let savedName = UserDefaults.standard.string(forKey: "userName")
        let name = (savedName?.isEmpty == false) ? savedName! : (user.displayName ?? "-")
        nameLabel.text = "Name: \(name)"

        // Role
        let role = UserDefaults.standard.string(forKey: "selectedRole") ?? "-"
        roleLabel.text = "Role: \(role)"
    }

    // MARK: - Settings
    @IBAction func settingsTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    // MARK: - Logout
    @IBAction func logoutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()

            // امسحي البيانات
            UserDefaults.standard.removeObject(forKey: "selectedRole")
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "userEmail")

            // رجوع لصفحة LoginType
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginTypeViewController")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)

        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
