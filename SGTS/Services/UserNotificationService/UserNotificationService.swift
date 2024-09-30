//
//  UserNotificationService.swift
// 05.08.2024.
//

import UserNotifications
import UIKit


protocol UserNotificationServiceProtocol {
    func sendLocalNotification(title: String, text: String)
    func updateBadgeCount(to count: Int)
}

final class UserNotificationService: NSObject, UserNotificationServiceProtocol {
    static let shared = UserNotificationService()

    private override init() {
        super.init()
        self.requestNotificationPermission()
    }
    
    func updateBadgeCount(to count: Int) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
                if #available(iOS 16.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(count) { error in
                        if let error = error {
                            Log.e("LNC Error setting badge count: \(error.localizedDescription)")
                        } else {
                            Log.i("LNC Badge count updated to \(count)")
                        }
                    }
                }
        }
    }
    
    func sendLocalNotification(title: String, text: String) {
        Log.i("LNC Send local notification with title: \(title) and text: \(text)")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = text
        content.sound = .default
        content.categoryIdentifier = "MESSAGE_CATEGORY"
        content.userInfo = ["important": true]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                Log.e("LNC Local notification send error: \(error.localizedDescription)")
            } else {
                Log.i("LNC Local notification was sended with text: \(text)")
            }
        }
    }

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { [weak self] granted, error in
            if let error = error {
                Log.e("LNC Ошибка при запросе разрешения на уведомления: \(error.localizedDescription)")
            } else if granted {
                Log.i("LNC Разрешение на уведомления предоставлено")
            } else {
                Log.e("LNC Разрешение на уведомления не предоставлено")
            }
            self?.getNotificationPermission()
        }
        center.delegate = self
    }

    private func getNotificationPermission() {
        checkNotificationPermission { [weak self] granted in
            if granted {
                print("LNC Notification permission granted")
                self?.registerNotificationCategory()
            } else {
                self?.promptToOpenSettings()
            }
        }
    }
    
    private func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    let badgeEnabled = settings.badgeSetting == .enabled
                    let alertEnabled = settings.alertSetting == .enabled
                    let soundEnabled = settings.soundSetting == .enabled
                    let lockScreenEnabled = settings.lockScreenSetting == .enabled
                    let notificationCenterEnabled = settings.notificationCenterSetting == .enabled
                    
                    // Логирование статусов
                    Log.i("LNC Badge setting: \(badgeEnabled ? "enabled" : "disabled")")
                    Log.i("LNC Alert setting: \(alertEnabled ? "enabled" : "disabled")")
                    Log.i("LNC Sound setting: \(soundEnabled ? "enabled" : "disabled")")
                    Log.i("LNC Lock screen setting: \(lockScreenEnabled ? "enabled" : "disabled")")
                    Log.i("LNC Notification center setting: \(notificationCenterEnabled ? "enabled" : "disabled")")

                    let allEnabled = badgeEnabled && alertEnabled && soundEnabled && lockScreenEnabled && notificationCenterEnabled
                    completion(allEnabled)
                    
                case .denied, .notDetermined:
                    Log.i("LNC Notification authorization status: \(settings.authorizationStatus == .denied ? "denied" : "not determined")")
                    completion(false)
                default:
                    Log.i("LNC Notification authorization status: unknown")
                    completion(false)
                }
            }
        }
    }
    
    private func promptToOpenSettings() {
        Log.i("LNC Open notification settings dialog")
        let alert = UIAlertController(title: "Notifications disabled", message: "Please enable notifications in Settings to receive alerts.", preferredStyle: .alert)
        let openSettingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                Log.i("LNC Open app settings")
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(openSettingsAction)
        alert.addAction(cancelAction)
        
        // Get the current window scene
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            let topController = rootViewController.topMostViewController()
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func registerNotificationCategory() {
        let replyAction = UNNotificationAction(identifier: "OPEN_ACTION",
                                               title: "Открыть",
                                               options: [.foreground])
        let dismissAction = UNNotificationAction(identifier: "DISMISS_ACTION",
                                                 title: "Отмена",
                                                 options: [.destructive])

        let category = UNNotificationCategory(identifier: "MESSAGE_CATEGORY",
                                              actions: [replyAction, dismissAction],
                                              intentIdentifiers: [],
                                              options: [.customDismissAction])

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

extension UserNotificationService: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Log.i("LNC Notification will present: \(notification.request.content.body)")
        if #available(iOS 14.0, *) {
            completionHandler([.alert, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Log.i("LNC Notification sended when app inactive: \(response.notification.request.content.body)")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}
