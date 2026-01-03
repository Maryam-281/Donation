//
//  NotificationdetailsController.swift
//  Donation
//
//  Created by BP-19-130-15 on 03/01/2026.
//

import UIKit

class NotificationdetailsController: UIViewController {

    @IBOutlet weak var goback: UIBarButtonItem!
    
    @IBOutlet weak var xx: UIBarButtonItem!
    
    @IBOutlet weak var detailTitle: UITextField!
    @IBOutlet weak var detailTime: UITextView!
    
    var receivedTitle: String?
        var receivedTime: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the text to the labels when the page opens [cite: 36, 37]
            detailTitle.text = receivedTitle ?? "Notification Detail"
            detailTime.text = receivedTime ?? "Just now"
        }
    
    
    @IBOutlet weak var vbutton: UIButton!
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
