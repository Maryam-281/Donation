//
//  DonationStore.swift
//  Donation
//
//  Created by BP-36-201-02 on 30/12/2025.
//

import Foundation
import UIKit

class DonationStore {

    static let shared = DonationStore()
    private init() {}

    var donations: [Donations] = [

        Donations(
            title: "Chicken with Broccoli and Rice",
            donationDescription: """
This Chicken with Broccoli and Rice is a delicious blend of succulent, savory chicken pieces and crisp, vibrant broccoli florets. It combines the tender texture of stir-fried chicken with the firm, satisfying bite of freshly steamed broccoli and the soft, fluffy texture of perfectly cooked white rice.
""",
            donorName: "Al Noor Restaurant",
            location: "Manama",
            category: "Prepared Meals",
            foodStatus: "Fresh",
            productionDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            expirationDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        ),

        Donations(
            title: "Pain Au Chocolat",
            donationDescription: """
A classic French pastry made with layers of buttery, flaky dough wrapped around rich dark chocolate. Each bite delivers a delicate crunch followed by a soft, melt-in-your-mouth texture.

Freshly baked and golden brown, this pastry is perfect for breakfast or a light snack and pairs wonderfully with coffee or tea.
""",
            donorName: "Paris Bakery",
            location: "Manama",
            category: "Baked Goods",
            foodStatus: "Fresh",
            productionDate: Date(),
            expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        ),

        Donations(
            title: "Fruit Salad",
            donationDescription: """
A refreshing mix of seasonal fruits including apples, oranges, grapes, and berries. Prepared fresh to preserve flavor and nutritional value, this fruit salad is light, hydrating, and naturally sweet.

It is ideal for a healthy snack or dessert option.
""",
            donorName: "Green Market",
            location: "Muharraq",
            category: "Fruits & Vegetables",
            foodStatus: "Expired",
            productionDate: Date(),
            expirationDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        ),

        Donations(
            title: "Bread",
            donationDescription: """
Freshly baked bread loaves with a crisp outer crust and a soft, airy interior. Made using traditional baking methods, this bread is perfect for sandwiches or as a side with meals.

Best enjoyed fresh.
""",
            donorName: "Local Bakery",
            location: "Southern Governorate",
            category: "Baked Goods",
            foodStatus: "Expires Soon",
            productionDate: Date(),
            expirationDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        ),

        Donations(
            title: "Vegetable Salad",
            donationDescription: """
A colorful assortment of freshly chopped vegetables including lettuce, tomatoes, cucumbers, and carrots. Lightly seasoned to enhance natural flavors, this salad offers a crisp and refreshing eating experience.

Ideal as a healthy side dish or light meal.
""",
            donorName: "Healthy Eats",
            location: "Northern Governorate",
            category: "Fruits & Vegetables",
            foodStatus: "Fresh",
            productionDate: Date(),
            expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        ),

        Donations(
            title: "Chicken Soup",
            donationDescription: """
A warm and comforting chicken soup prepared with tender chicken pieces, aromatic herbs, and fresh vegetables. Slow-cooked to develop rich flavors, this soup is soothing and nourishing.

Perfect for cooler days or anyone in need of a hearty meal.
""",
            donorName: "Home Kitchen",
            location: "Northern Governorate",
            category: "Prepared Meals",
            foodStatus: "Expires Soon",
            productionDate: Date(),
            expirationDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        )
    ]
}
