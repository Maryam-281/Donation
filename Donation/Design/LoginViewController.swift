import UIKit
import FirebaseAuth
import FirebaseFirestore

@MainActor
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController loaded")
    }

    // MARK: - Login
    @IBAction func loginButtonTapped(_ sender: UIButton) {

        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""

        guard !email.isEmpty, !password.isEmpty else {
            showAlert(title: "Missing Info", message: "Please enter email and password.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }

            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            print("✅ LOGIN SUCCESS:", result?.user.uid ?? "no uid")
            self.goToHome()
        }
    }

    // MARK: - Forgot Password
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {

        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !email.isEmpty else {
            showAlert(
                title: "Enter Email",
                message: "Please type your email first, then tap Forgot Password."
            )
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self else { return }

            if let error = error {
                self.showAlert(title: "Reset Failed", message: error.localizedDescription)
                return
            }

            self.showAlert(
                title: "Email Sent",
                message: "A password reset link has been sent to:\n\(email)"
            )
        }
    }

    // MARK: - Go To Home
    private func goToHome() {
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let homeVC = sb.instantiateViewController(withIdentifier: "HomeViewController")
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true)
    }

    // MARK: - Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
