//
//  collectorFeedbackViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit
import SwiftUICore

class collectorFeedbackViewController: UIViewController {

    @IBOutlet var packagingRatingbtns: [UIButton]!
    @IBOutlet var hygineRatingbtns: [UIButton]!
    @IBOutlet weak var commentsTextbox: UITextField!
    @IBOutlet weak var sentButton: UIButton!
   
    var packagingRating = 0 {
        didSet{
            for packagingRatingbtn in packagingRatingbtns{
                let imageName = (packagingRatingbtn.tag < packagingRating ? "circle.fill" : "circle")
                packagingRatingbtn.setImage(UIImage(systemName: imageName), for: .normal)
                packagingRatingbtn.tintColor = (packagingRatingbtn.tag < packagingRating ? .black : .darkText)
            }
        }
    }
    
    var hygineRating = 0 {
        didSet{
            for hygineRatingbtn in hygineRatingbtns{
                let imageName = (hygineRatingbtn.tag < hygineRating ? "circle.fill" : "circle")
                hygineRatingbtn.setImage(UIImage(systemName: imageName), for: .normal)
                hygineRatingbtn.tintColor = (hygineRatingbtn.tag < hygineRating ? .black : .darkText)
            }
        }
    }
    
    var comments : String = ""
    var colletingId : Int = 3
//    var colletingId : Int?
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//            if segue.identifier == "toDonationFilter" {
//    
//                // 1️⃣ Get the navigation controller
//                let navController = segue.destination as! UINavigationController
//    
//                // 2️⃣ Get the actual destination VC
//                let secondVC = navController.topViewController as! DonationFilter
//    
//                // 3️⃣ Pass the data
//                secondVC.colletingId = colletingId
//            }
//        }
    
    struct CollectorFeedback: Encodable {
        let packagingRate: Int
        let hygieneRate: Int
        let collectorComments: String
        let colletingId : Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentsTextbox.layer.borderColor = UIColor(red: 137/255, green: 170/255, blue: 197/255, alpha: 1.0).cgColor
    }
    
    @IBAction func PackagingTapped(_ sender: UIButton) {
        packagingRating = sender.tag + 1
        guard let index = packagingRatingbtns.firstIndex(of: sender) else {return}
        packagingRating = index + 1
    }
    
    @IBAction func hygineTapped(_ sender: UIButton) {
        hygineRating = sender.tag + 1
        guard let index = hygineRatingbtns.firstIndex(of: sender) else {return}
        hygineRating = index + 1
    }
    
    @IBAction func submitTapped(_ sender: UIButton)
    {
        guard hygineRating > 0 else {
            print("No rating is selected")
            return
        }
        guard packagingRating > 0 else {
            print("No rating is selected")
            return
        }
        // prevent double tap
        sender.isEnabled = false
        // Insert into Supabase
        if let   text = commentsTextbox.text, !text.isEmpty {
            comments = text
        }
        let feedback = CollectorFeedback(
            packagingRate: packagingRating,
            hygieneRate: hygineRating,
            collectorComments: comments,
            colletingId: colletingId)
         Task {
                do {
                    try await SupabaseManager.shared.client
                        .from("collectorFeedback")
                        .insert(feedback)
                        .execute()

                    print("✅ Insert success")
                } catch {
                    print("❌ Supabase error:", error)
                }
            }
    }
}
