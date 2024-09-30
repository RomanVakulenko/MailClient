//
//  UserProfileRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import Foundation

protocol UserProfileRoutingLogic {
    func routeToNameEditingScreen()
    func routeToPinCodeEditingScreen()
    func routeToSignatureScreen()
    func routeToReportScreen()
    func routeToInfoScreen()
    func routeToSideMenu()
}

protocol UserProfileDataPassing {
    var dataStore: UserProfileDataStore? { get }
}

final class UserProfileRouter: UserProfileRoutingLogic, UserProfileDataPassing {

    weak var viewController: UserProfileController?
    weak var dataStore: UserProfileDataStore?

    // MARK: - Public methods

    func routeToSideMenu() {
//        <#code#>
    }

    func routeToNameEditingScreen() {
        if let fullName = dataStore?.userFullName {
            let userChangeNameController = UserProfileChangeNameBuilder().getControllerWith(userFullName: fullName)
            userChangeNameController.modalPresentationStyle = .overFullScreen

            DispatchQueue.main.async { [weak self] in
                self?.viewController?.present(userChangeNameController, animated: true)
            }
        }
    }

    func routeToPinCodeEditingScreen() {
        let changePinCodeViewController = UserProfileChangePinCodeBuilder().getController()

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.pushViewController(changePinCodeViewController, animated: true)
        }
    }

    func routeToSignatureScreen() {
        let setSignatureViewController = UserProfileSetSignatureBuilder().getController()

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.pushViewController(setSignatureViewController, animated: true)
        }
    }

    func routeToReportScreen() {
        let sendReportViewController = UserProfileSendReportBuilder().getController()

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.pushViewController(sendReportViewController, animated: true)
        }
    }

    func routeToInfoScreen() {
        let aboutAppViewController = AboutAppScreenBuilder().getController()
        aboutAppViewController.modalPresentationStyle = .overFullScreen

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(aboutAppViewController, animated: true)
        }
    }

}
