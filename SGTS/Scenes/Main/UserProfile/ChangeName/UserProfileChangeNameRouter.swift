//
//  UserProfileChangeNameRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import Foundation

protocol UserProfileChangeNameRoutingLogic {
    func routeBack(from vc: UserProfileChangeNameController)
}

protocol UserProfileChangeNameDataPassing {
    var dataStore: UserProfileChangeNameDataStore? { get }
}

final class UserProfileChangeNameRouter: UserProfileChangeNameRoutingLogic, UserProfileChangeNameDataPassing {

    weak var viewController: UserProfileChangeNameController?
    weak var dataStore: UserProfileChangeNameDataStore?

    // MARK: - Public methods
//    func routeTo...Screen(viewModel: UserProfileChangeNameFlow.OnSelectItem.ViewModel) {
//
//        let controller = ...Builder().getController()
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.navigationController?.pushViewController(controller, animated: true)
//        }
//    }

    func routeBack(from vc: UserProfileChangeNameController) {
        vc.dismiss(animated: true)
    }
}
