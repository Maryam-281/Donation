//
//  CardView.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import UIKit

class CardView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 20
        layer.applySketchShadow()
    }
}
