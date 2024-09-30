//
//  UserNotificationManager.swift
// 05.08.2024.
//

import Foundation

protocol UserNotificationManagerProtocol {
    func sendLocalNotification(title: String, text: String)
    func updateBadgeCount(to count: Int)
}

final class UserNotificationManager: UserNotificationManagerProtocol {
    static let shared = UserNotificationManager()
    private var userNotificationService: UserNotificationServiceProtocol = DIManager.shared.container.resolve(UserNotificationServiceProtocol.self)!

    func sendLocalNotification(title: String, text: String) {
        userNotificationService.sendLocalNotification(title: title,
                                                      text: text)
    }
    
    func updateBadgeCount(to count: Int) {
        userNotificationService.updateBadgeCount(to: count)
    }
}
