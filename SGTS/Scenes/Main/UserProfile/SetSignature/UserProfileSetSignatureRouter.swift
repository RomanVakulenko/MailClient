//
//  UserProfileSetSignatureRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import Foundation

protocol UserProfileSetSignatureRoutingLogic {
    func doSaveSignature()
    func cancelAndGetBackToUserProfile()
}

protocol UserProfileSetSignatureDataPassing {
    var dataStore: UserProfileSetSignatureDataStore? { get }
}

final class UserProfileSetSignatureRouter: UserProfileSetSignatureRoutingLogic, UserProfileSetSignatureDataPassing {

    weak var viewController: UserProfileSetSignatureController?
    weak var dataStore: UserProfileSetSignatureDataStore?

    // MARK: - Public methods
    func doSaveSignature() {
        if let newSignature = dataStore?.newSignature {
                 UserDefaults.standard.set(newSignature, forKey: GlobalConstants.userSignature)
             }
    }

    func cancelAndGetBackToUserProfile () {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
