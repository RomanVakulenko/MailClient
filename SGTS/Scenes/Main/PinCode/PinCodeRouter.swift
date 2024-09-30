//
//  PinCodeRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import Foundation

protocol PinCodeRoutingLogic {
    func routeToNextScreen()
}

protocol PinCodeDataPassing {
    var dataStore: PinCodeDataStore? { get }
}

final class PinCodeRouter: PinCodeRoutingLogic, PinCodeDataPassing {

    weak var viewController: PinCodeController?
    weak var dataStore: PinCodeDataStore?

    func routeToNextScreen() {
        let controller = TabBarController()
        controller.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(controller, animated: true, completion: nil)
        }
    }
}
