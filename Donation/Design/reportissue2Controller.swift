//
//  reportissue2Controller.swift
//  Donation
//
//  Created by BP-19-130-15 on 03/01/2026.
//

import UIKit

class reportissue2Controller: UIViewController {

    @IBOutlet weak var goback: UIBarButtonItem!
    
    @IBOutlet weak var type: UIButton!
    
    @IBOutlet weak var message: UITextField!
    
    @IBOutlet weak var submit: UIButton!
    
    @IBAction func submitReport(_ sender: UIButton) {
        let issueDetail = message.text ?? ""
        
        if issueDetail.isEmpty {
            // Show an error if they didn't type anything
            let alert = UIAlertController(title: "Wait!", message: "Please describe the issue first.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            // Show a success message
            let alert = UIAlertController(title: "Reported!", message: "Thank you for letting us know. We are on it!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            // Clear the box for next time
            message.text = ""
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
