//
//  notificationsettingController.swift
//  Donation
//
//  Created by BP-36-201-09 on 01/01/2026.
//

import UIKit

class notificationsettingController: UIViewController {

    @IBOutlet weak var goback: UIBarButtonItem!
    
    @IBOutlet weak var xx: UIBarButtonItem!
    
    
    @IBAction func S1(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @IBAction func S2(_ sender: Any) {
    }
    
    @IBAction func S3(_ sender: Any) {
    }
    
    @IBAction func S4(_ sender: Any) {
    }
    
    @IBAction func S5(_ sender: UISwitch) {
        print(sender.isOn) 
    }
    
    @IBAction func S6(_ sender: Any) {
    }
    
    @IBAction func S7(_ sender: Any) {
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
