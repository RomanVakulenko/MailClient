//
//  UserProfileSendReportController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.07.2024.
//

import UIKit
import SnapKit

protocol UserProfileSendReportDisplayLogic: AnyObject {
    func displayUpdate(viewModel: UserProfileSendReportFlow.Update.ViewModel)

    func displayWaitIndicator(viewModel: UserProfileSendReportFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: UserProfileSendReportFlow.AlertInfo.ViewModel)

    func displayRouteToOpenImage(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel)
    func displayRouteToSaveDialog(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel)
    func displayRouteToImageFullScreen(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel)
    func displayRouteToOpenData(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel)

    func displayDropdownMenuAtNavBarIcons(viewModel: UserProfileSendReportFlow.OnDropdownMenu.ViewModel)
    func displayFileDialog(viewModel: UserProfileSendReportFlow.OnAttachBarButtonIcon.ViewModel)
    func displayRouteToAddressBookScreen(viewModel: UserProfileSendReportFlow.OnAddressIcon.ViewModel)
    func displaySending(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel)
    func displayRouteBack(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel)
}


// MARK: - UserProfileSendReportController

final class UserProfileSendReportController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {

    var interactor: UserProfileSendReportBusinessLogic?
    var router: (UserProfileSendReportRoutingLogic & UserProfileSendReportDataPassing)?
    
    lazy var contentView: UserProfileSendReportViewLogic = UserProfileSendReportView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Private properties

    private var didNavBarSet = false
    private var dropdownMenuOffset = CGFloat()
    private var isUserNowTakingAddressesForCopyField = false

    // MARK: - Lifecycle
    
    override func loadView() {
        contentView.output = self
        view = contentView
        hideNavigationBar(animated: false) //to hide flashing blue "< Back"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        interactor?.onDidLoadViews(request: UserProfileSendReportFlow.OnDidLoadViews.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if didNavBarSet == true {
            showNavigationBar(animated: false)
        }
    }

    // MARK: - Public methods

    func leftNavBarButtonDidTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    func rightNavBarButtonTapped(index: Int) {
        view.endEditing(true)
        switch index {
        case 0:
            interactor?.didTapSendNavBarIcon(request: UserProfileSendReportFlow.OnSendButton.Request())
        case 1:
            interactor?.didTapAttachNavBarIcon(request: UserProfileSendReportFlow.OnDropdownMenu.Request(dropDownMenuTitleCases: [.attachFile, .pickFotoFromGallary]))
        default: return
        }
    }

    // MARK: - Private methods
    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
}

// MARK: - UserProfileSendReportDisplayLogic

extension UserProfileSendReportController: UserProfileSendReportDisplayLogic {

    func displayRouteBack(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel) {
        router?.routeBack()
    }

    func displaySending(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel) {
        router?.routeSending()
    }

    func displayFileDialog(viewModel: UserProfileSendReportFlow.OnAttachBarButtonIcon.ViewModel) {
        router?.routeToDialog()
    }

    func displayRouteToSaveDialog(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel) {
        router?.routeToSaveDialog()
    }

    func displayRouteToOpenData(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel) {
        router?.routeToOpenData()
    }

    ///If photo - task router to show it
    func displayRouteToOpenImage(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel) {
        router?.routeToOpenImage()
    }

    func displayUpdate(viewModel: UserProfileSendReportFlow.Update.ViewModel) {
        if didNavBarSet == false {
            configureNavigationBar(navBar: viewModel.navBar)
            setNeedsStatusBarAppearanceUpdate()
            showNavigationBar(animated: true)

            didNavBarSet = true
        }
        if let navigationBarHeight = navigationController?.navigationBar.frame.height,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            dropdownMenuOffset = navigationBarHeight + statusBarHeight - 2
        }
        contentView.update(viewModel: viewModel)
    }


    func displayDropdownMenuAtNavBarIcons(viewModel: UserProfileSendReportFlow.OnDropdownMenu.ViewModel) {
        contentView.displayDropdownMenuAtNavBarIcons(viewModel: viewModel, dropdownMenuOffset: dropdownMenuOffset)
    }
    
    func displayRouteToImageFullScreen(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel) {
        router?.routeToOpenImage()
    }

    func displayRouteToAddressBookScreen(viewModel: UserProfileSendReportFlow.OnAddressIcon.ViewModel) {
        router?.routeToAddressBookScreen()
    }
    
    func displayWaitIndicator(viewModel: UserProfileSendReportFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: UserProfileSendReportFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - UserProfileSendReportViewOutput, UserProfileSendReportUpperViewOutput
extension UserProfileSendReportController: UserProfileSendReportViewOutput {

    func didTapSomeDropdownMenuTitle(titleViewModel: UserProfileSendReportModels.oneTitleOfDropdownMenu) {
        if titleViewModel.enumCaseOfDropdownMenu == .pickFotoFromGallary {
            self.chooseImagePicker(source: .photoLibrary)
        } else {
            interactor?.didTapSomeDropdownMenuTitle(request: UserProfileSendReportFlow.OnDropdownMenuTitle.Request(enumCase: titleViewModel.enumCaseOfDropdownMenu))
        }
    }

    func didTapAtXButtonAtCloudAttachment(_ viewModel: CloudEmailAttachmentViewModel) {
        interactor?.didTapXButtonAttachedCloud(
            request: UserProfileSendReportFlow.OnXButtonAttachedCloud.Request(id: viewModel.id))
    }
    
    func onChangeTextInTextView(_ viewModel: TextViewCellViewModel,
                                currentText: String) {
        interactor?.useTextOfTextViewCell(request: UserProfileSendReportFlow.OnTextViewDidChange.Request(
            textInEmailTextViewCell: currentText))
    }

    func useEnteredTextAt(subject: String?) {
        interactor?.useTextAtSubjectToCopyFields(request: UserProfileSendReportFlow.Update.Request(subject: subject))
    }

    func didTapAtCloudAttachment(_ viewModel: CloudEmailAttachmentViewModel){
        interactor?.didTapAtFileOrFoto(request: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Request(cloudEmailViewModel: viewModel))
    }

    func didTapAtFoto(_ viewModel: FotoCellViewModel) {
        interactor?.didTapAtFileOrFoto(request: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Request(fotoViewModel: viewModel))
    }

    func didTapAtDownloadIcon(_ viewModel: FotoCellViewModel) {
        interactor?.didTapDownloadIcon(request: UserProfileSendReportFlow.OnDownloadIconOrToSaveAttachedFile.Request())
    }

    func didTapAtQuattroIcon(_ viewModel: FotoCellViewModel) {
        interactor?.didTapQuattroIcon(request: UserProfileSendReportFlow.OnQuattroIcon.Request())
    }

    func didTapSendButton(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel) {
        interactor?.didTapSendButton(request: UserProfileSendReportFlow.OnSendButton.Request())
    }

}



// MARK: - UIDocumentPickerDelegate
extension UserProfileSendReportController: UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        Log.i("Выбран файл: \(url)")
        interactor?.didPickFotoFromGallaryOrFileFromDocumentsAt(urls: urls)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        Log.i("Выбор файла отменен")
    }

    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.allowsEditing = true
            imgPicker.sourceType = source
            present(imgPicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer { dismiss(animated: true) }

        guard let editedImage = info[.editedImage] as? UIImage,
              let imageData = editedImage.jpegData(compressionQuality: 1.0)
        else { return }

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let imagePath = documentsURL.appendingPathComponent("\(getName()).jpg")

        do {
            try imageData.write(to: imagePath)
            Log.i("imageData была записана по адресу: \(imagePath)")
            interactor?.didPickFotoFromGallaryOrFileFromDocumentsAt(urls: [imagePath])
        } catch {
            Log.i("Ошибка при сохранении image: \(error)")
        }
    }


    func getName() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""

        let nameLenght = 10
        for _ in 0..<nameLenght {
            if let randomChar = letters.randomElement() {
                randomString += String(randomChar)
            }
        }
        return randomString
    }
}
