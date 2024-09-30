//
//  CustomNavigationController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.07.2024.
//

import UIKit

final class CustomNavigationController: UINavigationController {

    // MARK: - Private properties
    private var notificationObservers: [NSObjectProtocol] = []


    // MARK: - Lifecycle
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        subscribeToNotifications()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Private methods
    private func subscribeToNotifications() {
        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.userNameAndEmail,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .userNameAndEmail)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.incoming,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .incoming)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.sent,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .sent)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.outgoing,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .outgoing)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.drafts,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .drafts)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.archived,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .archived)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.deleted,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .deleted)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.attachments,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .attachments)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.settings,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .settings)
            }
        )

        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.searchContactsAtServer,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.handleNotification(for: .searchContactsAtServer)
            }
        )
        notificationObservers.append(NotificationCenter.default.addObserver(
            forName: Notification.Name.closeSideMenuAtSwipe,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.showAndEnableTabBarItems()
                self?.unsubscribeFromNotifications()
            }
        )
    }

    private func unsubscribeFromNotifications() {
        notificationObservers.removeAll()
    }

    private func showAndEnableTabBarItems() {
        tabBarController?.tabBar.layer.zPosition = 100
        tabBarController?.tabBar.isUserInteractionEnabled = true
    }

    private func handleNotification(for menuItem: SideMenuModel.MenuItems) {
        showAndEnableTabBarItems()

        switch menuItem {
        case .userNameAndEmail:
            tabBarController?.selectedIndex = 1
        case .incoming:
            setViewControllers([MailStartScreenBuilder().getControllerFor(messageType: .incoming)], animated: false)
        case .sent:
            setViewControllers([MailStartScreenBuilder().getControllerFor(messageType: .sent)], animated: false)
        case .outgoing:
            setViewControllers([MailStartScreenBuilder().getControllerFor(messageType: .outgoing)], animated: false)
        case .drafts:
            setViewControllers([MailStartScreenBuilder().getControllerFor(messageType: .drafts)], animated: false)
        case .archived:
            setViewControllers([MailStartScreenBuilder().getControllerFor(messageType: .archived)], animated: false)
        case .deleted:
            setViewControllers([MailStartScreenBuilder().getControllerFor(messageType: .deleted)], animated: false)
        case .attachments:
            let attachmentsVC = AttachmentsScreenBuilder().getController()
            setViewControllers([attachmentsVC], animated: false)
        case .settings:
            tabBarController?.selectedIndex = 1
        case .searchContactsAtServer:
            setViewControllers([AddressBookBuilder().getControllerWith(alreadyTakenEmailAddresses: nil,
                                                                       delegate: nil,
                                                                       searchFrom: .server)],
                               animated: false)
        }
        unsubscribeFromNotifications()
    }
}
