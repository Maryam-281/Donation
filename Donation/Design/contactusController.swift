//
//  contactusController.swift
//  Donation
//
//  Created by BP-36-201-09 on 01/01/2026.
//

import UIKit

class contactusController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var message: UITextField!
    
    @IBAction func submitTapped(_ sender: UIButton) {
        if name.text == "" || email.text == "" {
            print("Missing information")
        } else {
            performSegue(withIdentifier: "showSuccess", sender: self)
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
