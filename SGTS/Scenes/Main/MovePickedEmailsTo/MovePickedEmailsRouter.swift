//
//  MovePickedEmailsRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import Foundation

protocol MovePickedEmailsRoutingLogic {
    func routeBackToEmailPickingScreen(from vc: MovePickedEmailsController)
}

protocol MovePickedEmailsDataPassing {
    var dataStore: MovePickedEmailsDataStore? { get }
}

final class MovePickedEmailsRouter: MovePickedEmailsRoutingLogic, MovePickedEmailsDataPassing {


    weak var viewController: MovePickedEmailsController?
    weak var dataStore: MovePickedEmailsDataStore?

    // MARK: - Public methods
//    func routeTo...Screen(viewModel: MovePickedEmailsFlow.OnSelectItem.ViewModel) {
//
//        let controller = ...Builder().getController()
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.navigationController?.pushViewController(controller, animated: true)
//        }
//    }

    func routeBackToEmailPickingScreen(from vc: MovePickedEmailsController) {
        vc.dismiss(animated: true)
    }
}
