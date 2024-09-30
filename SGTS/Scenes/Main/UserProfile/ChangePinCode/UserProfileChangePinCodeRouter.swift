//
//  UserProfileChangePinCodeRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import Foundation

protocol UserProfileChangePinCodeRoutingLogic {
    func doSavePincode()
    func cancelAndGetBackToUserProfile()
}

protocol UserProfileChangePinCodeDataPassing {
    var dataStore: UserProfileChangePinCodeDataStore? { get }
}

final class UserProfileChangePinCodeRouter: UserProfileChangePinCodeRoutingLogic, UserProfileChangePinCodeDataPassing {

    weak var viewController: UserProfileChangePinCodeController?
    weak var dataStore: UserProfileChangePinCodeDataStore?

    // MARK: - Public methods
    func doSavePincode() {
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.navigationController?.pushViewController(TabBarController(), animated: true)
//        }
    }

    func cancelAndGetBackToUserProfile () {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
