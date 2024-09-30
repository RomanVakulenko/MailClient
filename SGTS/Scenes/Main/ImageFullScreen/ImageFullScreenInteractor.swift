//
//  ImageFullScreenInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import Foundation
import UIKit

protocol ImageFullScreenBusinessLogic {
    func passImageToPresent(request: ImageFullScreenFlow.OnDidLoadViews.Request)
    func didTapBackArrow()
    func didTapThreeDotsIcon(request: ImageFullScreenFlow.OnDropdownMenu.Request)
    func didTapSomeDropdownMenuTitle(request: ImageFullScreenFlow.OnDropdownMenuTitle.Request)
}


protocol ImageFullScreenDataStore: AnyObject {
    var imageToOpen: UIImage { get }
    var fileNameWithExt: String { get }
    var mailUidl: String { get }
    var fileDataToSave: Data { get }
}

final class ImageFullScreenInteractor: ImageFullScreenBusinessLogic, ImageFullScreenDataStore {

    // MARK: - Public properties

    var presenter: ImageFullScreenPresentationLogic?
    var worker: ImageFullScreenWorkingLogic?

    var imageToOpen: UIImage
    var fileNameWithExt: String
    var mailUidl: String
    var fileDataToSave = Data()

    // MARK: - Private properties
    private var fileSizeForSubview = Int()

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(imageToOpen: UIImage, fileName: String, mailUidl: String?, size: Int?) {
        self.imageToOpen = imageToOpen
        self.fileNameWithExt = fileName
        self.mailUidl = mailUidl ?? ""
        self.fileSizeForSubview = size ?? Int()
    }

    // MARK: - Private properties

    // MARK: - Public methods
    func passImageToPresent(request: ImageFullScreenFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        
        presenter?.presentUpdate(response: ImageFullScreenFlow.Update.Response(
            image: imageToOpen,
            fileName: fileNameWithExt,
            fileSize: fileSizeForSubview))
    }

    func didTapBackArrow() {
        presenter?.didTapBackArrow()
    }

    func didTapThreeDotsIcon(request: ImageFullScreenFlow.OnDropdownMenu.Request) {
        presenter?.presentDropdownMenu(response: ImageFullScreenFlow.OnDropdownMenu.Response(dropDownMenuTitleCases: request.dropDownMenuTitleCases))
    }

//    func didTapSomeDropdownMenuTitle(request: ImageFullScreenFlow.OnDropdownMenuTitle.Request) {
//        switch request.enumCase {
//        case .downloadFoto:
//            presenter?.presentRouteToSaveDialog(response: ImageFullScreenFlow.OnDropdownMenuTitle.Response())
//        case .openImageInOtherApp:
//            presenter?.presentRouteToOpenImageInOtherApp(response: ImageFullScreenFlow.OnDropdownMenuTitle.Response())
//        }
//    }

    func didTapSomeDropdownMenuTitle(request: ImageFullScreenFlow.OnDropdownMenuTitle.Request) {
        switch request.enumCase {
        case .downloadFoto:
            presenter?.presentWaitIndicator(response: ImageFullScreenFlow.OnWaitIndicator.Response(isShow: true))

            worker?.getMail(byUIDL: mailUidl) { [weak self] result in
                guard let self else {return}
                presenter?.presentWaitIndicator(response: ImageFullScreenFlow.OnWaitIndicator.Response(isShow: false))
                switch result {
                case .success(let oneEmailMessage):
                    Log.i("OneMailData got successfully")

                    for oneAttachment in oneEmailMessage.attachments {
                        if oneAttachment.filename == self.fileNameWithExt {
                            fileDataToSave = oneAttachment.content
                        }
                    }

                case .failure(let error):
                    Log.e("Failed to get email data: \(error.localizedDescription)")
                    presenter?.presentAlert(response: ImageFullScreenFlow.AlertInfo.Response(error: error))
                }
            }
            presenter?.presentRouteToSaveDialog(response: ImageFullScreenFlow.OnDropdownMenuTitle.Response())

        case .openImageInOtherApp:
            presenter?.presentRouteToOpenImageInOtherApp(response: ImageFullScreenFlow.OnDropdownMenuTitle.Response())
        }
    }


    //MARK: - Private methods

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(
                    response: ImageFullScreenFlow.Update.Response(image: imageToOpen,
                                                                  fileName: fileNameWithExt,
                                                                  fileSize: fileSizeForSubview))
            }
    }

    ///Light or Dark theme
    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(
                    response: ImageFullScreenFlow.Update.Response(image: imageToOpen,
                                                                  fileName: fileNameWithExt,
                                                                  fileSize: fileSizeForSubview))
            }
    }

}
