//
//  OneContactDetailsRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.04.2024.
//

import UIKit

protocol OneContactDetailsRoutingLogic {
    func routeBackToAddressBook(viewModel: OneContactDetailsFlow.RoutePayload.ViewModel)
    func callNumber()
}

protocol OneContactDetailsDataPassing {
    var dataStore: OneContactDetailsDataStore? { get }
}

protocol OneContactDetailsDelegate: AnyObject {
    func useEmailFromOneContactDetails(pickedEmailAddress: String, isMultiPickingMode: Bool)
}


final class OneContactDetailsRouter: OneContactDetailsRoutingLogic, OneContactDetailsDataPassing {

    // MARK: - Public properties
    weak var viewController: OneContactDetailsController?
    weak var dataStore: OneContactDetailsDataStore?

    // MARK: - Public methods

    func routeBackToAddressBook(viewModel: OneContactDetailsFlow.RoutePayload.ViewModel) {
        if let addressDelegate = viewController?.delegate,
           let pickedOneEmailAddress = dataStore?.onePickedEmailAddress,
           let isMultiPickingMode = dataStore?.isMultiPickingMode {
            addressDelegate.useEmailFromOneContactDetails(
                pickedEmailAddress: pickedOneEmailAddress,
                isMultiPickingMode: isMultiPickingMode)
        }

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: false)
        }

    }

    func callNumber() {
        if let phone = dataStore?.phoneNumber,
           let url = URL(string: "telprompt://\(phone)") {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
