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
    case collected
    case completed
    case scheduled
}

class Donations {

    // MARK: - Food Info
    let title: String
    let donationDescription: String
    let donorName: String
    let location: String
    let category: String
    let foodStatus: String
    let imageName: String

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
        imageName: String,
        productionDate: Date,
        expirationDate: Date
    ) {
        self.title = title
        self.donationDescription = donationDescription
        self.donorName = donorName
        self.location = location
        self.category = category
        self.foodStatus = foodStatus
        self.imageName = imageName
        self.productionDate = productionDate
        self.expirationDate = expirationDate
        self.pickupStatus = .available
        self.pickupDate = nil
    }
}


