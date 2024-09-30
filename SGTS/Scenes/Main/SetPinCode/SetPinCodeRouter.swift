//
//  SetPinCodeRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation

protocol SetPinCodeRoutingLogic {
    func routeToTabBarScreen()
}

protocol SetPinCodeDataPassing {
    var dataStore: SetPinCodeDataStore? { get }
}

final class SetPinCodeRouter: SetPinCodeRoutingLogic, SetPinCodeDataPassing {

    weak var viewController: SetPinCodeController?
    weak var dataStore: SetPinCodeDataStore?

    // MARK: - Public methods
    func routeToTabBarScreen() {
        let controller = TabBarController()
        controller.hidesBottomBarWhenPushed = true
        controller.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(controller, animated: true)
        }
    }
}
