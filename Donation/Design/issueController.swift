//
//  issueController.swift
//  Donation
//
//  Created by BP-36-201-09 on 01/01/2026.
//

import UIKit

class issueController: UIViewController {

    @IBOutlet weak var type: UIButton!
    let issues = ["Food & Donation Issues", "Pickup Issues", "User Behavior Issues"]
    
    @IBOutlet weak var issue1: UITextView!
    @IBOutlet weak var issue2: UITextView!
    @IBOutlet weak var issue3: UITextView!
    
    @IBOutlet weak var message: UITextField!
    

    @IBAction func submitReport(_ sender: UIButton) {
        performSegue(withIdentifier: "reportSuccess", sender: self)
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
