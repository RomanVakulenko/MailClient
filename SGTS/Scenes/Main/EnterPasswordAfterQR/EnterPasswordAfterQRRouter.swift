//
//  EnterPasswordAfterQRRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation

protocol EnterPasswordAfterQRRoutingLogic {
    func routeToEnterQRPassword()
}

protocol EnterPasswordAfterQRDataPassing {
    var dataStore: EnterPasswordAfterQRDataStore? { get }
}

final class EnterPasswordAfterQRRouter: EnterPasswordAfterQRRoutingLogic, EnterPasswordAfterQRDataPassing {

    weak var viewController: EnterPasswordAfterQRController?
    weak var dataStore: EnterPasswordAfterQRDataStore?

    // MARK: - Public methods
    func routeToEnterQRPassword() {
        let controller = EnterQRPasswordBuilder().getController()
        DispatchQueue.main.async { [weak self] in
                self?.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
