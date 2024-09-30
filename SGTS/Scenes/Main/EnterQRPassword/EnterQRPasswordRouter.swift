//
//  EnterQRPasswordRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation

protocol EnterQRPasswordRoutingLogic {
    func routeToEnterKeyFilePasswordScreen()
}

protocol EnterQRPasswordDataPassing {
    var dataStore: EnterQRPasswordDataStore? { get }
}

final class EnterQRPasswordRouter: EnterQRPasswordRoutingLogic, EnterQRPasswordDataPassing {

    weak var viewController: EnterQRPasswordController?
    weak var dataStore: EnterQRPasswordDataStore?

    // MARK: - Public methods
    func routeToEnterKeyFilePasswordScreen() {
        let controller = SetPinCodeBuilder().getController()
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
