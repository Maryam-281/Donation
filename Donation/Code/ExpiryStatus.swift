//
//  ExpiryStatus.swift
//  Donation
//
//  Created by BP-19-130-14 on 04/01/2026.
//

import Foundation
import UIKit

enum ExpiryStatus {
    case expired
    case expiresSoon
    case fresh

    var text: String {
        switch self {
        case .expired: return "Expired"
        case .expiresSoon: return "Expires soon"
        case .fresh: return "Fresh"
        }
    }

    var color: UIColor {
        switch self {
        case .expired: return .systemRed
        case .expiresSoon: return .systemOrange
        case .fresh: return .systemGreen
        }
    }
}
