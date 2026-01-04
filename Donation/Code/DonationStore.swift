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
            imageName: "chicken",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 6))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 11))!
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
            imageName: "painau",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 19))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 21))!
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
            imageName: "fruit_salad",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 2))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 4))!
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
            imageName: "bread",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 23))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 27))!
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
            imageName: "salad",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 14))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 16))!
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
            imageName: "chicken_soup",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 25))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 29))!
        ),

      

        Donations(
            title: "Beef Biryani",
            donationDescription: """
A fragrant and flavorful rice dish made with tender pieces of beef slow-cooked in a blend of traditional spices and herbs. The basmati rice is infused with rich aromas, creating layers of flavor in every bite.

This hearty meal is filling, comforting, and perfect for sharing, making it a popular choice for lunch or dinner.
""",

            donorName: "Spice Route",
            location: "Riffa",
            category: "Prepared Meals",
            imageName: "biryani",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 10))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 15))!
        ),

        Donations(
            title: "Assorted Donuts",
            donationDescription: """
A delightful box of freshly baked donuts featuring a variety of flavors and toppings. Each donut is soft, fluffy, and carefully glazed or topped to provide a perfect balance of sweetness.

Ideal for sharing at gatherings, enjoying as a dessert, or pairing with a warm cup of coffee or tea.
"""
,
            donorName: "Sweet Corner",
            location: "Manama",
            category: "Desserts",
            imageName: "donuts",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 17))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 20))!
        ),

        Donations(
            title: "Fresh Oranges",
            donationDescription: """
Juicy and naturally sweet oranges sourced from local farms and selected for freshness. These oranges are rich in vitamin C and offer a refreshing burst of flavor with every bite.

Perfect for snacking, juicing, or adding to fruit salads and healthy meals.
""",
            donorName: "Farm Fresh",
            location: "Isa Town",
            category: "Fruits & Vegetables",
            imageName: "oranges",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 8))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 18))!
        ),

        Donations(
            title: "Cheese Sandwiches",
            donationDescription: """
Simple yet satisfying cheese sandwiches prepared using fresh bread and sliced cheese. Each sandwich offers a soft texture with a mild, comforting flavor that appeals to all ages.

Ideal for quick meals, school lunches, or light snacks throughout the day.
"""
,
            donorName: "School Cafeteria",
            location: "Muharraq",
            category: "Prepared Meals",
            imageName: "sandwich",
            productionDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 1))!,
            expirationDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 3))!
        )
    ]
}
