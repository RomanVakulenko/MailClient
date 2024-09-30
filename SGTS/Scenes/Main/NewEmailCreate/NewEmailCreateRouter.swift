//
//  NewEmailCreateRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import Foundation
import UIKit
import SnapKit

protocol NewEmailCreateRoutingLogic {
    func routeToSaveDialog()
    func routeToOpenImage()
    func routeToFileDialog()
    func routeToOpenData()
    func routeSending()
    func routeBack()

    func routeToAddressBookScreen()
}

protocol NewEmailCreateDataPassing {
    var dataStore: NewEmailCreateDataStore? { get }
}


final class NewEmailCreateRouter: NewEmailCreateRoutingLogic, NewEmailCreateDataPassing, FileShareable {

    weak var viewController: NewEmailCreateController?
    weak var dataStore: NewEmailCreateDataStore?

    private enum Constants {
        static let publicItem = "public.item"
    }

    // MARK: - Public methods

    func routeToFileDialog() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [Constants.publicItem], in: .import)
        documentPicker.delegate = viewController
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(documentPicker, animated: true)
        }
    }

    func routeToSaveDialog() {
//        guard let store = dataStore,
//              let vc = viewController else { return }
//        vc.shareFile(data: Data(), filenameWithExt: store.fileNameWithExt, from: vc)
    }

    func routeToOpenImage() {
        if let image = dataStore?.imageToOpen,
           let name = dataStore?.fileNameWithExt,
           let size = dataStore?.fileSize {
            let imageViewController = ImageFullScreenBuilder().getController(
                with: image,
                fileNameWithExt: name,
                size: size)

            DispatchQueue.main.async { [weak self] in
                self?.viewController?.navigationController?.pushViewController(imageViewController, animated: true)
            }
        }
    }

    func routeToAddressBookScreen() {
        var alreadyTakenEmailAddresses = [String]()

        guard let viewControllers = viewController?.navigationController?.viewControllers else { return }
        let amountOfVCsInStack = viewControllers.count

        if dataStore?.shouldReturnToSearchContactsFromServer == true &&
            (viewControllers[amountOfVCsInStack - 2] is AddressBookController) {
            DispatchQueue.main.async { [weak self] in
                if let navigationController = self?.viewController?.navigationController {
                    TabBarManager.showAndEnableTabBarFor(navController: navigationController)
                    navigationController.popViewController(animated: false)
                }
            }
        }

        if dataStore?.shouldReturnToSearchContactsFromServer == false {
            if dataStore?.isUserNowTakingAddressesForCopyField == true {
                if let emails = dataStore?.emailAddressesAtCopyField {
                    alreadyTakenEmailAddresses = emails
                }
            } else if dataStore?.isUserNowTakingAddressesForCopyField == false {
                alreadyTakenEmailAddresses = dataStore?.arrayFromRecipientEmails ?? []
            }

            let addressBookController = AddressBookBuilder().getControllerWith(
                alreadyTakenEmailAddresses: alreadyTakenEmailAddresses,
                delegate: viewController,
                searchFrom: .database)

            DispatchQueue.main.async { [weak viewController] in
                if let navigationController = viewController?.navigationController {
                    TabBarManager.hideAndDisableTabBarFor(navController: navigationController)
                    navigationController.pushViewController(addressBookController, animated: false)
                }
            }
        }

    }

    func routeBack() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: true)
        }
    }

    func routeToOpenData() {
        guard let store = dataStore,
              let vc = viewController else { return }

        OpenFileManager.shared.openData(store.fileDataForOpen,
                                        withFilename: store.fileNameWithExt,
                                        currentViewController: vc)
    }

    func routeSending() {

    }

    // MARK: - Private methods

    private func openData(_ data: Data, withFilename filename: String) {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(filename)

        do {
            // Запись данных во временный файл
            try data.write(to: fileURL)

            // Проверка, что файл существует
            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                print("File does not exist at path: \(fileURL.path)")
                return
            }

            // Проверка, что можно открыть URL
            guard UIApplication.shared.canOpenURL(fileURL) else {
                print("Cannot open file at path: \(fileURL.path)")
                return
            }

            // Открытие файла с использованием UIApplication.shared
            UIApplication.shared.open(fileURL, options: [:]) { success in
                if success {
                    print("File opened successfully.")
                } else {
                    print("Failed to open file.")
                }
            }
        } catch {
            print("Failed to write data to temporary file: \(error)")
        }
    }

}
