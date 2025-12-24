//
//  DonationFilter.swift
//  Donation
//
//  Created by BP-36-201-09 on 24/12/2025.
//

import Foundation

enum Category: String, CaseIterable {
    case preparedMeals = "Prepared Meals"
    case fruitsVegetables = "Fruits & Vegetables"
    case bakedGoods = "Baked Goods"
    case drinks = "Drinks"
    case dairyProducts = "Dairy Products"
}

enum Location: String, CaseIterable {
    case muharraq = "Muharraq"
    case northern = "Northern Governate"
    case southern = "Southern Governate"
    case manama = "Manama"
}

enum Status: String, CaseIterable {
    case fresh = "Fresh"
    case expiresSoon = "Expires Soon"
    case expired = "Expired"
}

struct Donation {
    let title: String
    let category: Category
    let location: Location
    let status: Status
}
