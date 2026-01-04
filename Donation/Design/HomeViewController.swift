import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🏠 Home loaded")
    }

    @IBAction func goToProfileTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
