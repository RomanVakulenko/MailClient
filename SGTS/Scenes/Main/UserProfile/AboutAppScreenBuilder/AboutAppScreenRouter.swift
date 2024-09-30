//
//  AboutAppScreenRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import Foundation

protocol AboutAppScreenRoutingLogic {
    func routeBack()
    func routeToSendLog()
}

final class AboutAppScreenRouter: AboutAppScreenRoutingLogic {

    weak var viewController: AboutAppScreenController?

    // MARK: - Public methods

    func routeBack() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
    
    func routeToSendLog() {
        guard let vc = viewController else { return }
        LogToMail.shared.sendLogsByEmail(from: vc)
    }
}
