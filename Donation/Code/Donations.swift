//
//  Donations.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import Foundation
enum PickupStatus {
    case pending
    case accepted
    case collected
    case completed
}

struct Donations {
    let location: String
    let status: String        // food status (Fresh, Expired)
    let category: String
    let title: String

    // NEW (safe additions)
    var pickupStatus: PickupStatus = .pending
    var pickupTime: Date? = nil
}
