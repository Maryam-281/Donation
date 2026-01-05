import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!          // ✅ NEW
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    private let saveUserToFirestore = true

    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ SignUpViewController loaded")

        // ✅ optional (يسهل الإدخال)
        phoneTextField.keyboardType = .phonePad
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("✅ Sign Up button tapped")

        let name = (nameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let email = (emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = (phoneTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)   // ✅ NEW
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""

        // Validations
        if name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert("Please fill all fields")
            return
        }

        if password != confirmPassword {
            showAlert("Passwords do not match")
            return
        }

        if password.count < 6 {
            showAlert("Password must be at least 6 characters")
            return
        }

        // ✅ optional validation بسيط للتلفون (سهل)
        if phone.count < 8 {
            showAlert("Phone number is too short")
            return
        }

        // Create user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ createUser error:", error.localizedDescription)
                self.showAlert(error.localizedDescription)
                return
            }

            guard let user = result?.user else {
                self.showAlert("Something went wrong. No user.")
                return
            }

            let uid = user.uid
            print("✅ User created with UID:", uid)

            // ✅ 1) خزّني الاسم والايميل والتلفون محليًا (اختياري)
            UserDefaults.standard.set(name, forKey: "userName")
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(phone, forKey: "userPhone")   // ✅ NEW

            // ✅ 2) خزّني الاسم داخل FirebaseAuth displayName
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { err in
                if let err = err {
                    print("❌ Failed to set displayName:", err.localizedDescription)
                } else {
                    print("✅ displayName saved in FirebaseAuth")
                }
            }

            // ✅ 3) Save extra info in Firestore (الأهم عشان Profile/Edit)
            if self.saveUserToFirestore {
                let db = Firestore.firestore()
                let data: [String: Any] = [
                    "fullName": name,   // ✅ خليته fullName عشان يكون موحد
                    "email": email,
                    "phone": phone,     // ✅ NEW
                    "createdAt": FieldValue.serverTimestamp(),
                    "role": (UserDefaults.standard.string(forKey: "selectedRole") ?? "donor").lowercased()
                ]

                db.collection("users").document(uid).setData(data, merge: true) { err in
                    if let err = err {
                        print("❌ Firestore save error:", err.localizedDescription)
                        self.showAlert("Saved account, but failed to save profile data.")
                    } else {
                        print("✅ Firestore user saved")
                    }

                    // ✅ Success + رجوع لصفحة Login
                    self.showAlert("Account created ✅") {
                        self.dismiss(animated: true)
                    }
                }

            } else {
                // ✅ إذا ما تبين Firestore
                self.showAlert("Account created ✅") {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    // MARK: - Helpers
    private func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
