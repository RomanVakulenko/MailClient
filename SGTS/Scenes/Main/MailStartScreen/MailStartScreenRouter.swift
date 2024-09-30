//
//  MailStartScreenRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import UIKit

protocol MailStartScreenRoutingLogic {
    func routeToOneEmailDetailsScreen()
    func routeToNewEmailCreate(emailType: NewEmailCreateModels.NewReOrFwdEmailType)
    func routeToEmailPickingScreen()
    func routeToSideMenu()
}

protocol MailStartScreenDataPassing {
    var dataStore: MailStartScreenDataStore? { get }
}

final class MailStartScreenRouter: MailStartScreenRoutingLogic, MailStartScreenDataPassing {

    weak var viewController: MailStartScreenController?
    weak var dataStore: MailStartScreenDataStore?

    // MARK: - Public methods

    func routeToSideMenu() {
        let sideMenuController = SideMenuBuilder().getController()

        sideMenuController.modalPresentationStyle = .custom
        sideMenuController.modalTransitionStyle = .coverVertical

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(sideMenuController, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.viewController?.tabBarController?.tabBar.layer.zPosition = -1
                self?.viewController?.tabBarController?.tabBar.isUserInteractionEnabled = false
            }
        }
    }

    func routeToOneEmailDetailsScreen() {
        if let id = dataStore?.idOfSelectedMail,
           let typeFromSideMenu = dataStore?.messageTypeFromSideMenu {
            let controller = OneEmailDetailsBuilder().getControllerWith(
                id: id,
                messageTypeFromSideMenu: typeFromSideMenu)

            DispatchQueue.main.async { [weak self] in
                if let navigationController = self?.viewController?.navigationController {
                    TabBarManager.hideAndDisableTabBarFor(navController: navigationController)
                    navigationController.pushViewController(controller, animated: true)
                }
            }
        }
    }

    func routeToNewEmailCreate(emailType: NewEmailCreateModels.NewReOrFwdEmailType) {
        let controller = NewEmailCreateBuilder().getControllerWith(
            messageModel: nil,
            pickedEmailAddresses: nil,
            emailType: emailType)

        DispatchQueue.main.async { [weak self] in
            if let navigationController = self?.viewController?.navigationController {
                TabBarManager.hideAndDisableTabBarFor(navController: navigationController)
                navigationController.pushViewController(controller, animated: true)
            }
        }
    }

    func routeToEmailPickingScreen() {
        if let id = dataStore?.idOfSelectedMail,
           let mailsForDisplay = dataStore?.mailsForDisplay,
           let messageTypeFromSideMenu = dataStore?.messageTypeFromSideMenu {
            let controller = EmailPickingScreenBuilder().getControllerWith(
                pickedEmailId: id,
                mailsForDisplay: mailsForDisplay,
                messageTypeFromSideMenu: messageTypeFromSideMenu)

            DispatchQueue.main.async { [weak self] in
                if let navigationController = self?.viewController?.navigationController {
                    TabBarManager.hideAndDisableTabBarFor(navController: navigationController)
                    navigationController.pushViewController(controller, animated: true)
                }
            }
        }
    }

}
