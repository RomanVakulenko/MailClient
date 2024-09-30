//
//  SecretKeySelectorRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import Foundation
import UIKit

protocol SecretKeySelectorRoutingLogic {
    func routeToSetPincodeScreen()
    func routeToDialog()
    func routeToBrowserAuth(completion: @escaping (Result<Void, SecretKeySelectorModel.RouteError>) -> Void)
}

protocol SecretKeySelectorDataPassing {
    var dataStore: SecretKeySelectorDataStore? { get }
}


final class SecretKeySelectorRouter: SecretKeySelectorRoutingLogic, SecretKeySelectorDataPassing {
    
    private enum Constants {
        static let publicItem = "public.item"
    }
    weak var viewController: SecretKeySelectorController?
    weak var dataStore: SecretKeySelectorDataStore?
    
    // MARK: - Public methods
    func routeToSetPincodeScreen() {
        let controller = SetPinCodeBuilder().getController()
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func routeToDialog() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [Constants.publicItem], in: .import)
        documentPicker.delegate = viewController
        documentPicker.modalPresentationStyle = .formSheet
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(documentPicker, animated: true)
        }
    }

    func routeToBrowserAuth(completion: @escaping (Result<Void, SecretKeySelectorModel.RouteError>) -> Void) {
        guard let urlToBrowserAuth = dataStore?.urlToBrowserAuth,
              let url = URL(string: urlToBrowserAuth) else {
            completion(.failure(SecretKeySelectorModel.RouteError.invalidURL))
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(SecretKeySelectorModel.RouteError.cannotOpenURL))
                }
            }
        } else {
            completion(.failure(SecretKeySelectorModel.RouteError.cannotOpenURL))
        }
    }
}


//"public.item" в местные крнстанты
