//
//  ImageFullScreenRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import Foundation
import UIKit
import SnapKit

protocol ImageFullScreenRoutingLogic {
    func routeToOpenImage()
    func routeToSaveDialog()
    func openImageInOtherApp()
    func routeBack()
}

protocol ImageFullScreenDataPassing {
    var dataStore: ImageFullScreenDataStore? { get }
}


final class ImageFullScreenRouter: ImageFullScreenRoutingLogic, ImageFullScreenDataPassing, FileShareable {

    weak var viewController: ImageFullScreenController?
    weak var dataStore: ImageFullScreenDataStore?

    // MARK: - Public methods

    func routeBack() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: false)
        }
    }

    func routeToOpenImage( ) {
        let imageViewController = UIViewController()
        imageViewController.modalPresentationStyle = .formSheet

        let imageView = UIImageView(image: dataStore?.imageToOpen)
        imageView.contentMode = .scaleAspectFill
        imageViewController.view.addSubview(imageView)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(imageViewController, animated: true)
        }
    }

    ///didTapDownloadLabel in contextMenu
    func routeToSaveDialog( ) {
        guard let store = dataStore,
              let vc = viewController else { return }
//        vc.shareFile(data: store.fileData, filename: store.fileNameWithExt.string, from: vc)
        vc.shareFile(data: Data(), filenameWithExt: store.fileNameWithExt, from: vc)
    }


    func openImageInOtherApp( ) {
        guard let store = dataStore,
              let vc = viewController else { return }
        openImageWithActivityViewController(from: vc, image: store.imageToOpen)
    }


    private func openImageWithActivityViewController(from viewController: UIViewController, image: UIImage) {
        guard let imageURL = saveImageToDocumentDirectory(image: image) else {
            print("Ошибка сохранения изображения")
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
        // Устранение проблемы на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        viewController.present(activityViewController, animated: true, completion: nil)
    }

    private func saveImageToDocumentDirectory(image: UIImage) -> URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "tempImage.jpg"
        let fileURL = documentDirectory?.appendingPathComponent(fileName)

        if let data = image.jpegData(compressionQuality: 1.0), let url = fileURL {
            try? data.write(to: url)
            return url
        }
        return nil
    }
}
