//
//  notificationController.swift
//  Donation
//
//  Created by BP-36-201-09 on 01/01/2026.
//

import UIKit

class notificationController: UIViewController {

    @IBOutlet weak var goback: UIBarButtonItem!
    
    @IBOutlet weak var settings: UIBarButtonItem!
    
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var titleLabel1: UITextView!
    @IBOutlet weak var timeLabel1: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // STEP 1: Create a fake notification
            NotificationManager.shared.addNotification(
                title: "Your donation was accepted!"
            )
        
        // STEP 2: Load it into the UI
            loadNotification()
        // Do any additional setup after loading the view.
    }
    
    func loadNotification() {
        let list = NotificationManager.shared.notifications

        if let first = list.first {
            titleLabel1.text = first
            timeLabel1.text = "Just now"
        }
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
