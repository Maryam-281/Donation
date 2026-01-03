//
//  contactusController.swift
//  Donation
//
//  Created by BP-36-201-09 on 01/01/2026.
//

import UIKit

class contactusController: UIViewController {

    @IBOutlet weak var goback: UIBarButtonItem!
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var message: UITextField!
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        let userName = name.text ?? ""
        let userEmail = email.text ?? ""
        let userMessage = message.text ?? ""

        // 2. Simple check to see if they filled it out
        if !userName.isEmpty && !userEmail.isEmpty {
            print("Sending message from \(userName)...")
            
            // 3. Show a "Thank You" pop-up
            let alert = UIAlertController(title: "Sent!", message: "We got your message and will help you soon.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
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
