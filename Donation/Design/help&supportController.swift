//
//  help&supportController.swift
//  Donation
//
//  Created by BP-19-130-15 on 03/01/2026.
//

import UIKit

class help_supportController: UIViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var reportIssueButton: UIButton!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var guidelinesButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    @IBAction func didTapSupportButton(_ sender: UIButton) {
            
            switch sender {
            case aboutUsButton:
                performSegue(withIdentifier: "toAboutUs", sender: self)
            case faqButton:
                performSegue(withIdentifier: "toFAQs", sender: self)
            case guidelinesButton:
                performSegue(withIdentifier: "toGuidelines", sender: self)
            case contactUsButton:
                performSegue(withIdentifier: "toContactUs", sender: self)
            case reportIssueButton:
                performSegue(withIdentifier: "toReportIssue", sender: self)
            case termsButton:
                performSegue(withIdentifier: "toTerms", sender: self)
            case privacyButton:
                performSegue(withIdentifier: "toPrivacyPolicy", sender: self)
            case backButton:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
