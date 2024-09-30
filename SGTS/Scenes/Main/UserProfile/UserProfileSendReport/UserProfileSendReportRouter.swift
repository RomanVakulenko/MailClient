//
//  UserProfileSendReportRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.07.2024.
//

import Foundation
import UIKit
import SnapKit

protocol UserProfileSendReportRoutingLogic {
    func routeToSaveDialog()
    func routeToOpenImage()
    func routeToDialog()
    func routeToOpenData()
    func routeSending()
    func routeBack()

    func routeToAddressBookScreen()
}

protocol UserProfileSendReportDataPassing {
    var dataStore: UserProfileSendReportDataStore? { get }
}


final class UserProfileSendReportRouter: UserProfileSendReportRoutingLogic, UserProfileSendReportDataPassing, FileShareable {

    weak var viewController: UserProfileSendReportController?
    weak var dataStore: UserProfileSendReportDataStore?

    private enum Constants {
        static let publicItem = "public.item"
    }

    // MARK: - Public methods

    func routeSending() {

    }

    func routeBack() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: true)
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

    func routeToSaveDialog() { //нужен ли в письме-отчете функционал сохранения файла по тапу на аттачмент/на иконку под фотоПревью?
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

    func routeToAddressBookScreen() { }

    func routeToOpenData() {
        guard let store = dataStore,
              let vc = viewController else { return }

        OpenFileManager.shared.openData(store.fileDataForOpen,
                                        withFilename: store.fileNameWithExt,
                                        currentViewController: vc)
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
