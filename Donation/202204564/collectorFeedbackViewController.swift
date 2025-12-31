//
//  collectorFeedbackViewController.swift
//  Donation
//
//  Created by macOS on 31/12/2025.
//

import UIKit

class collectorFeedbackViewController: UIViewController {

    @IBOutlet var packagingRatingbtns: [UIButton]!
    @IBOutlet var hygineRatingbtns: [UIButton]!
    @IBOutlet weak var commentsTextbox: UITextField!
   
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
    

}
