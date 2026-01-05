import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentData()
    }

    // MARK: - Load existing data
    private func loadCurrentData() {
        // الاسم
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            fullNameTextField.text = savedName
        } else if let name = Auth.auth().currentUser?.displayName {
            fullNameTextField.text = name
        }

        // رقم الهاتف
        if let phone = UserDefaults.standard.string(forKey: "userPhone") {
            phoneTextField.text = phone
        }
    }

    // MARK: - Save
    @IBAction func saveTapped(_ sender: UIButton) {

        let name = (fullNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = (phoneTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        if name.isEmpty || phone.isEmpty {
            showAlert("Please fill all fields")
            return
        }

        guard let user = Auth.auth().currentUser else {
            showAlert("User not logged in")
            return
        }

        // ✅ 1) حفظ محلي (عشان Profile)
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(phone, forKey: "userPhone")

        // ✅ 2) تحديث الاسم في FirebaseAuth
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if let error = error {
                print("❌ Failed to update display name:", error.localizedDescription)
            } else {
                print("✅ Display name updated")
            }
        }

        // ✅ 3) حفظ الاسم + التلفون في Firestore
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "name": name,
            "phone": phone
        ]) { error in
            if let error = error {
                print("❌ Firestore update error:", error.localizedDescription)
            } else {
                print("✅ Firestore profile updated")
            }
        }

        showAlert("Profile updated ✅") {
            self.dismiss(animated: true)
        }
    }

    // MARK: - Back
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: - Alert
    private func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
