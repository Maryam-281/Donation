import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

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
            phoneLabel.text = "Phone: -"
            return
        }

        // ✅ أول شي عرض بيانات سريعة من UserDefaults / FirebaseAuth
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail")
        let email = savedEmail ?? user.email ?? "-"
        emailLabel.text = "Email: \(email)"

        let savedName = UserDefaults.standard.string(forKey: "userName")
        let name = (savedName?.isEmpty == false) ? savedName! : (user.displayName ?? "-")
        nameLabel.text = "Name: \(name)"

        let roleLocal = UserDefaults.standard.string(forKey: "selectedRole") ?? "-"
        roleLabel.text = "Role: \(roleLocal)"

        let savedPhone = UserDefaults.standard.string(forKey: "userPhone") ?? "-"
        phoneLabel.text = "Phone: \(savedPhone)"

        // ✅ بعدها نجيب البيانات الأحدث من Firestore
        let uid = user.uid
        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { [weak self] snap, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Firestore read error:", error.localizedDescription)
                return
            }

            guard let data = snap?.data() else { return }

            // ✅ name ممكن تكون name أو fullName حسب شنو حفظتي
            let nameFS = (data["name"] as? String) ?? (data["fullName"] as? String)
            let emailFS = data["email"] as? String
            let roleFS  = data["role"] as? String
            let phoneFS = data["phone"] as? String

            if let nameFS, !nameFS.isEmpty {
                self.nameLabel.text = "Name: \(nameFS)"
                UserDefaults.standard.set(nameFS, forKey: "userName")
            }

            if let emailFS, !emailFS.isEmpty {
                self.emailLabel.text = "Email: \(emailFS)"
                UserDefaults.standard.set(emailFS, forKey: "userEmail")
            }

            if let roleFS, !roleFS.isEmpty {
                self.roleLabel.text = "Role: \(roleFS.capitalized)"
                UserDefaults.standard.set(roleFS, forKey: "selectedRole")
            }

            if let phoneFS, !phoneFS.isEmpty {
                self.phoneLabel.text = "Phone: \(phoneFS)"
                UserDefaults.standard.set(phoneFS, forKey: "userPhone")
            }
        }
    }

    // MARK: - Edit
    @IBAction func editTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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

            UserDefaults.standard.removeObject(forKey: "selectedRole")
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userPhone")

            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginTypeViewController")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)

        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
