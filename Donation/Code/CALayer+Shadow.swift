//
//  CALayer+Shadow.swift
//  Donation
//
//  Created by BP-36-201-10 on 31/12/2025.
//

import Foundation
import UIKit

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
        shadowRadius = blur / 2
        masksToBounds = false

        if spread != 0 {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
