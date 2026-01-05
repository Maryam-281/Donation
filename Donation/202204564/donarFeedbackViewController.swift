//
//  donarFeedbackViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import SwiftUICore

class donarFeedbackViewController: UIViewController {
    
    @IBOutlet var ratingButtons: [UIButton]!
    @IBOutlet weak var commentsTextbox: UITextField!
    @IBOutlet weak var sentButton: UIButton!
    
    // variables
    
    var rating = 0 {
        didSet{
            for ratingButton in ratingButtons{
                let imageName = (ratingButton.tag < rating ? "circle.fill" : "circle")
                ratingButton.setImage(UIImage(systemName: imageName), for: .normal)
                ratingButton.tintColor = (ratingButton.tag < rating ? .black : .darkText)
            }
        }
    }
    
    var comments : String = ""
    var donationId : Int = 0
//    var donationId : Int?
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //            if segue.identifier == "toDonationFilter" {
    //
    //                // 1️⃣ Get the navigation controller
    //                let navController = segue.destination as! UINavigationController
    //
    //                // 2️⃣ Get the actual destination VC
    //                let secondVC = navController.topViewController as! 'segue name'
    //
    //                // 3️⃣ Pass the data
    //                secondVC.donationId = donationId
    //            }
    //        }
    
    struct DonerFeedback: Encodable {
        let pickupTime: Int
        let DonerComments: String
        let donationid : Int
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        commentsTextbox.layer.borderColor = UIColor(red: 137/255, green: 170/255, blue: 197/255, alpha: 1.0).cgColor
    }
    
    // Funtions
    //Rating Buttons
    @IBAction func rateTapped(_ sender: UIButton) {
        rating = sender.tag + 1
        guard let index = ratingButtons.firstIndex(of: sender) else { return }
        rating = index + 1
    }
    //Submit Buttons
    @IBAction func submitTapped(_ sender: UIButton)
    {
        guard rating > 0 else {
            print("No rating is selected")
            return
        }

        // prevent double tap
        sender.isEnabled = false
        
        // Insert into Supabase
        if let   text = commentsTextbox.text, !text.isEmpty {
            comments = text
        }
        let feedback = DonerFeedback(
                pickupTime: rating,
                DonerComments: comments,
                donationid: donationId )
         Task {
                do {
                    try await SupabaseManager.shared.client
                        .from("DonerFeedback")
                        .insert(feedback)
                        .execute()

                    print("✅ Insert success")
                } catch {
                    print("❌ Supabase error:", error)
                }
            }

    }
}
