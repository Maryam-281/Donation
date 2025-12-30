//
//  FAQController.swift
//  Donation
//
//  Created by BP-36-201-01 on 30/12/2025.
//

import UIKit

class FAQController: UIViewController {

    @IBOutlet weak var a1: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        a1.layer.isHidden = false

        // Do any additional setup after loading the view.
    }
    

    @IBAction func q1(_ sender: Any) {
        a1.layer.isHidden = true
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
