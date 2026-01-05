import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SettingsViewController: UIViewController {

    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var usersListButton: UIButton!
    @IBOutlet weak var donationHistoryButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var addNewUserButton: UIButton!
    @IBOutlet weak var reportListButton: UIButton!
    @IBOutlet weak var helpSupportButton: UIButton!
    @IBOutlet weak var createNewAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyAllHidden()              // ✅ يخفي الكل بالبداية
        loadRoleAndApplyUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRoleAndApplyUI()
    }

    private func loadRoleAndApplyUI() {

        // ✅ 1) Fallback سريع من UserDefaults (بس مؤقت)
        let localRole = (UserDefaults.standard.string(forKey: "selectedRole") ?? "donor")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        applyRoleUI(localRole)

        // ✅ 2) المصدر الأساسي: Firestore
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snap, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Firestore read role error:", error.localizedDescription)
                return
            }

            let roleFS = (snap?.data()?["role"] as? String ?? localRole)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            print("✅ ROLE USED:", roleFS)   // ✅ مهم للتأكد بالـ Console

            // خزنيها محلياً كـ cache
            UserDefaults.standard.set(roleFS, forKey: "selectedRole")

            // طبّقي UI
            self.applyRoleUI(roleFS)
        }
    }

    private func applyAllHidden() {
        let allButtons = [
            aboutUsButton,
            editProfileButton,
            usersListButton,
            donationHistoryButton,
            notificationsButton,
            addNewUserButton,
            reportListButton,
            helpSupportButton,
            createNewAccountButton
        ]

        allButtons.forEach {
            $0?.isHidden = true
            $0?.isEnabled = false
        }
    }

    private func applyRoleUI(_ roleString: String) {

        applyAllHidden() // ✅ أهم شي: كل مرة نخفي الكل قبل نعرض الصح

        switch roleString {
        case "donor":
            show([aboutUsButton, editProfileButton, donationHistoryButton, notificationsButton, helpSupportButton])

        case "collector":
            show([aboutUsButton, editProfileButton, notificationsButton, reportListButton, helpSupportButton])

        case "admin":
            show([aboutUsButton, usersListButton, addNewUserButton, reportListButton, notificationsButton, createNewAccountButton])

        default:
            show([aboutUsButton, editProfileButton, helpSupportButton])
        }
    }

    private func show(_ buttons: [UIButton?]) {
        buttons.forEach {
            $0?.isHidden = false
            $0?.isEnabled = true
        }
    }
}
