//
//  HomePageViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 27/12/2025.
//

import UIKit

class HomePageViewController: UIViewController {
  
    @IBOutlet weak var shadowView: UIView!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        shadowView.layer.cornerRadius = 20
        shadowView.layer.applySketchShadow()
    }

}



extension CALayer {

    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.15,
        x: CGFloat = 0,
        y: CGFloat = 20,
        blur: CGFloat = 15,
        spread: CGFloat = 0
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        masksToBounds = false

        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

