//
//  NotificationManager.swift
//  Donation
//
//  Created by BP-19-130-15 on 03/01/2026.
//

import Foundation

class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    var notifications: [String] = []

    func addNotification(title: String) {
        notifications.insert(title, at: 0)
    }
}
