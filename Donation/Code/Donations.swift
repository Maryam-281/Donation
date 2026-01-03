//
//  Donations.swift
//  Donation
//
//  Created by BP-36-201-09 on 28/12/2025.
//

import Foundation

enum PickupStatus {
    case available
    case scheduled
    case accepted
    case collected
    case completed
}

class Donations {

    // MARK: - Core Donation Info
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

    // MARK: - Pickup Tracking
    var pickupStatus: PickupStatus
    var pickupDate: Date?
    var pickupNote: String?   // ← for user notes

    // MARK: - Designated Initializer
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

        // Default pickup values
        self.pickupStatus = .available
        self.pickupDate = nil
        self.pickupNote = nil
    }

    // MARK: - Convenience Init (optional, safe)
    convenience init() {
        self.init(
            title: "",
            donationDescription: "",
            donorName: "",
            location: "",
            category: "",
            foodStatus: "",
            imageName: "",
            productionDate: Date(),
            expirationDate: Date()
        )
    }
}


