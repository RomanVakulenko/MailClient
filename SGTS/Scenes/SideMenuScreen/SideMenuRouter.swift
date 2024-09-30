//
//  SideMenuRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import UIKit

protocol SideMenuRoutingLogic {
    func routeToSelectedScreen()
    func closeSideMenu()
}

protocol SideMenuDataPassing {
    var dataStore: SideMenuDataStore? { get }
}

final class SideMenuRouter: SideMenuRoutingLogic, SideMenuDataPassing {

    // MARK: - Public properties
    weak var viewController: SideMenuController?
    weak var dataStore: SideMenuDataStore?

    // MARK: - Public methods

    func routeToSelectedScreen() {
        if let selectedScreen = dataStore?.selectedScreen {
            NotificationCenter.default.post(
                name: Notification.Name(selectedScreen.rawValue),
                object: nil,
                userInfo: [selectedScreen.rawValue: true]
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) { [weak self] in
            self?.viewController?.dismiss(animated: false)
        }
    }

    func closeSideMenu() {
        NotificationCenter.default.post(
            name: Notification.Name.closeSideMenuAtSwipe,
            object: nil,
            userInfo: [Notification.Name.closeSideMenuAtSwipe: true]
        )

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: false)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.viewController?.dismiss(animated: false)
//        }
    }
}
