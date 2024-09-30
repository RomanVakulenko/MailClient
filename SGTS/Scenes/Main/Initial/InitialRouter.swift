//
//  InitialRouter.swift
// 01.04.2024.
//

import UIKit

protocol InitialRoutingLogic {
    func routeToLogInRegistr()
    func routeToPinCode()
    func routeToTabBarScreen()
}

protocol InitialDataPassing {
    var dataStore: InitialDataStore? { get }
}


final class InitialRouter: InitialRoutingLogic, InitialDataPassing {

    // MARK: - Public properties
    weak var viewController: InitialController?
    weak var dataStore: InitialDataStore?

    // MARK: - Private properties
    func routeToLogInRegistr() {
        let controller = LogInRegistrBuilder().getController()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(navigationController, animated: true)
        }
    }

    func routeToPinCode() {
        let controller = PinCodeBuilder().getController()
        controller.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(controller, animated: true)
        }
    }
    
    func routeToTabBarScreen() {
        let controller = TabBarController()
        controller.hidesBottomBarWhenPushed = true
        controller.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(controller, animated: true)
        }
    }
}
