import UIKit

class LoginTypeViewController: UIViewController {

    @IBAction func userTypeTapped(_ sender: UIButton) {

        var role = ""

        switch sender.tag {
        case 1:
            role = "Donor"
        case 2:
            role = "Collector"
        case 3:
            role = "Admin"
        default:
            return
        }

        UserDefaults.standard.set(role, forKey: "selectedRole")

        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        ) as! LoginViewController

        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
