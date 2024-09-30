//
//  EmailPickingScreenRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import Foundation

protocol EmailPickingScreenRoutingLogic {
    func routeToMailStartScreen()
    func routeToMovePickedEmailsScreen()
}

protocol EmailPickingScreenDataPassing {
    var dataStore: EmailPickingScreenDataStore? { get }
}

final class EmailPickingScreenRouter: EmailPickingScreenRoutingLogic, EmailPickingScreenDataPassing {


    weak var viewController: EmailPickingScreenController?
    weak var dataStore: EmailPickingScreenDataStore?

    // MARK: - Public methods
    func routeToMovePickedEmailsScreen() {
        if let pickedIdsOfEmails = dataStore?.storedIdsOfPickedEmails {
            let movePickedEmailsController = MovePickedEmailsBuilder().getControllerWith(pickedEmailIds: pickedIdsOfEmails)

            movePickedEmailsController.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.present(movePickedEmailsController, animated: true)
            }
        }
    }

    func routeToMailStartScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
