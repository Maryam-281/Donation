
import UIKit

class HomeViewController: UIViewController {

    @IBAction func goToProfileTapped(_ sender: UIButton) {

        // ✅ إذا الاسم/الإيميل مو موجودين (مثلاً لوجين بس وما عنده displayName)
        // نحط قيم تجريبية فقط
        if (UserDefaults.standard.string(forKey: "userName") ?? "").isEmpty {
            UserDefaults.standard.set("User", forKey: "userName")
        }

        if (UserDefaults.standard.string(forKey: "userEmail") ?? "").isEmpty {
            UserDefaults.standard.set("user@email.com", forKey: "userEmail")
        }

        // ✅ Role موجود من LoginType عادة
        if (UserDefaults.standard.string(forKey: "selectedRole") ?? "").isEmpty {
            UserDefaults.standard.set("Donor", forKey: "selectedRole")
        }

        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
