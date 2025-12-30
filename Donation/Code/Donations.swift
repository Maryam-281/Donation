//
//  Donations.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import UIKit
import Foundation


enum PickupStatus {
    case available
    case accepted
    case scheduled
    case pickedUp
}

class Donations {

    // MARK: - Food Info
    let title: String
    let donationDescription: String
    let donorName: String
    let location: String
    let category: String
    let foodStatus: String   // ✅ Fresh / Expired / Expires Soon

    // MARK: - Dates
    let productionDate: Date
    let expirationDate: Date

    // MARK: - Pickup
    var pickupStatus: PickupStatus
    var pickupDate: Date?

    init(
        title: String,
        donationDescription: String,
        donorName: String,
        location: String,
        category: String,
        foodStatus: String,
        productionDate: Date,
        expirationDate: Date
    ) {
        self.title = title
        self.donationDescription = donationDescription
        self.donorName = donorName
        self.location = location
        self.category = category
        self.foodStatus = foodStatus
        self.productionDate = productionDate
        self.expirationDate = expirationDate
        self.pickupStatus = .available
        self.pickupDate = nil
    }
}



