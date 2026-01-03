import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // يجي من LoginType
    var selectedRole: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedRole.isEmpty {
            selectedRole = UserDefaults.standard.string(forKey: "selectedRole") ?? ""
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {

        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""

        if email.isEmpty || password.isEmpty {
            showAlert("Please enter email and password")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }

            // خزّني الدور
            if !self.selectedRole.isEmpty {
                UserDefaults.standard.set(self.selectedRole, forKey: "selectedRole")
            }

            // خزّني الإيميل لعرضه في Profile
            if let userEmail = result?.user.email {
                UserDefaults.standard.set(userEmail, forKey: "userEmail")
            }

            // نجيب الاسم من Firestore (إذا موجود) ونخزنه
            if let uid = result?.user.uid {
                Firestore.firestore().collection("users").document(uid).getDocument { doc, _ in
                    if let data = doc?.data(),
                       let name = data["name"] as? String,
                       !name.isEmpty {
                        UserDefaults.standard.set(name, forKey: "userName")
                    }
                    // بعدين روحي Home
                    self.goToHome()
                }
            } else {
                self.goToHome()
            }
        }
    }

    private func goToHome() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    // Forgot Password
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {

        let alert = UIAlertController(
            title: "Reset Password",
            message: "Enter your email address",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }

        let sendAction = UIAlertAction(title: "Send", style: .default) { _ in
            let email = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            if email.isEmpty {
                self.showAlert("Please enter your email")
                return
            }

            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.showAlert(error.localizedDescription)
                } else {
                    self.showAlert("Password reset email sent ✅ (Check inbox / spam)")
                }
            }
        }

        alert.addAction(sendAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
