//
//  AddressBookBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 29.05.2024.
//

import UIKit

protocol AddressBookBuilderProtocol: AnyObject {
    func getControllerWith(alreadyTakenEmailAddresses: [String]?,
                           delegate: AddressBookGetAdressesDelegate?,
                           searchFrom: TypeOfSearch) -> UIViewController
}

enum TypeOfSearch {
    case database, server
}

final class AddressBookBuilder: AddressBookBuilderProtocol {

    func getControllerWith(alreadyTakenEmailAddresses: [String]?,
                           delegate: AddressBookGetAdressesDelegate?,
                           searchFrom: TypeOfSearch) -> UIViewController {

        let viewController = AddressBookController(delegate: delegate,
                                                   searchFrom: searchFrom)
        let interactor = AddressBookInteractor(emailAddresses: alreadyTakenEmailAddresses ?? [],
                                               searchFrom: searchFrom)
        let presenter = AddressBookPresenter()
        let worker = AddressBookWorker()
        let router = AddressBookRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
