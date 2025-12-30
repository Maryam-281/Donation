//
//  Donations.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import Foundation
enum PickupStatus {
    case available
    case accepted
    case scheduled
    case pickedUp
}

struct Donations {
    let location: String
    let status: String
    let category: String
    let title: String

    var pickupStatus: PickupStatus = .available
    var pickupDate: Date? = nil
}

