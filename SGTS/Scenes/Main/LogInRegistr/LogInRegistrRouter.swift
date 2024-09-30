//
//  LogInRegistrRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.04.2024.
//

import UIKit

protocol LogInRegistrRoutingLogic {
    func routeToSecretKeySelectorScreen()
    func routeToQRScanScreen()
}

protocol LogInRegistrDataPassing {
    var dataStore: LogInRegistrDataStore? { get }
}


final class LogInRegistrRouter: LogInRegistrRoutingLogic, LogInRegistrDataPassing {

    // MARK: - Public properties
    weak var viewController: LogInRegistrController?
    weak var dataStore: LogInRegistrDataStore?

    // MARK: - Public methods
    func routeToSecretKeySelectorScreen() {

        ///for checking EnterPasswordAfterQR
//        let controller = EnterPasswordAfterQRBuilder().getController()
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.navigationController?.pushViewController(controller, animated: true)
//        }

        ///for checking SecretKeySelector
        let controller = SecretKeySelectorBuilder().getController()
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.pushViewController(controller, animated: true)
        }

        ///for checking AttachmentsScreen
//        let controller = AttachmentsScreenBuilder().getController()
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.navigationController?.pushViewController(controller, animated: true)
//        }

    }

    func routeToQRScanScreen() {

        ///for checking PinCodeScreen
//        let controller = PinCodeBuilder().getController()
//        controller.modalPresentationStyle = .fullScreen
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.present(controller, animated: true)
//        }

        DispatchQueue.main.async { [weak self] in
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .fullScreen

            self?.viewController?.present(tabBarController, animated: true)
        }
    }
}
