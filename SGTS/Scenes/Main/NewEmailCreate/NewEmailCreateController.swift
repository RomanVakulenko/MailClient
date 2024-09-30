//
//  NewEmailCreateController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import UIKit
import SnapKit

protocol NewEmailCreateDisplayLogic: AnyObject {
    func displayUpdate(viewModel: NewEmailCreateFlow.Update.ViewModel)

    func displayWaitIndicator(viewModel: NewEmailCreateFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: NewEmailCreateFlow.AlertInfo.ViewModel)

    func displayRouteToOpenImage(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel)
    func displayRouteToSaveDialog(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel)
    func displayRouteToImageFullScreen(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel)
    func displayRouteToOpenData(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel)
    func displayRouteBack(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel)

    func displayDropdownMenuAtNavBarIcons(viewModel: NewEmailCreateFlow.OnDropdownMenu.ViewModel)
    func displayFileDialog(viewModel: NewEmailCreateFlow.OnAttachBarButtonIcon.ViewModel)
    func displayRouteToAddressBookScreen(viewModel: NewEmailCreateFlow.OnAddressIcon.ViewModel)
    func displaySending(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel)
}


// MARK: - NewEmailCreateController

final class NewEmailCreateController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {

    var interactor: NewEmailCreateBusinessLogic?
    var router: (NewEmailCreateRoutingLogic & NewEmailCreateDataPassing)?
    
    lazy var contentView: NewEmailCreateViewLogic = NewEmailCreateView()

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
        interactor?.onDidLoadViews(request: NewEmailCreateFlow.OnDidLoadViews.Request(isEmptyViewVisible: false))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if didNavBarSet == true {
            showNavigationBar(animated: false)
        }
    }

    func leftNavBarButtonDidTapped() {
        if let viewControllers = self.navigationController?.viewControllers {
            let amountOfVCsInStack = viewControllers.count

            //if previous VC is AddressBookController
            if viewControllers[amountOfVCsInStack - 2] is AddressBookController {
                interactor?.didTapBackBarButton(request: AddressBookFlow.RoutePayload.Request())
            } else {
                interactor?.requestForSavingDraft(request: AddressBookFlow.RoutePayload.Request())
            }
        }
    }

    func rightNavBarButtonTapped(index: Int) {
        view.endEditing(true)
        
        switch index {
        case 0:
            interactor?.didTapSomeRightNavBarButton(request: NewEmailCreateFlow.OnDropdownMenu.Request(
                menuID: .threeDotsMenu,
                dropDownMenuTitleCases: [.deleteMail, .saveDraft]))
        case 1:
            interactor?.didTapSendButton(request: NewEmailCreateFlow.OnSendButton.Request())
        case 2:
            interactor?.didTapSomeRightNavBarButton(request: NewEmailCreateFlow.OnDropdownMenu.Request(
                menuID: .attachmentMenu,
                dropDownMenuTitleCases: [.attachFile, .pickFotoFromGallary]))
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

// MARK: - NewEmailCreateDisplayLogic

extension NewEmailCreateController: NewEmailCreateDisplayLogic {

    func displayFileDialog(viewModel: NewEmailCreateFlow.OnAttachBarButtonIcon.ViewModel) {
        router?.routeToFileDialog()
    }

    func displayRouteToSaveDialog(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel) {
        router?.routeToSaveDialog()
    }

    func displayRouteToOpenData(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel) {
        router?.routeToOpenData()
    }

    func displayRouteBack(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel) {
        router?.routeBack()
    }

    ///If photo - task router to show it
    func displayRouteToOpenImage(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel) {
        router?.routeToOpenImage()
    }

    func displaySending(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel) {
        router?.routeSending()
    }

    func displayUpdate(viewModel: NewEmailCreateFlow.Update.ViewModel) {
        if didNavBarSet == false {
            configureNavigationBar(navBar: viewModel.navBar)
            showNavigationBar(animated: false)

            didNavBarSet = true
        }
        if let navigationBarHeight = navigationController?.navigationBar.frame.height,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            dropdownMenuOffset = navigationBarHeight + statusBarHeight - 2
        }
        
        contentView.update(viewModel: viewModel)
    }

    func displayDropdownMenuAtNavBarIcons(viewModel: NewEmailCreateFlow.OnDropdownMenu.ViewModel) {
        contentView.displayDropdownMenuAtNavBarIcons(viewModel: viewModel, dropdownMenuOffset: dropdownMenuOffset)
    }
    
    func displayRouteToImageFullScreen(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel) {
        router?.routeToOpenImage()
    }

    func displayRouteToAddressBookScreen(viewModel: NewEmailCreateFlow.OnAddressIcon.ViewModel) {
        router?.routeToAddressBookScreen()
    }
    
    func displayWaitIndicator(viewModel: NewEmailCreateFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: NewEmailCreateFlow.AlertInfo.ViewModel) {
        if viewModel.text == getString(.newEmailCreateSavingDraft) {

            showAlert(title: viewModel.title,
                      message: viewModel.text,
                      firstButtonTitle: viewModel.buttonTitle ?? "Ok",
                      firstButtonCompletion: { self.interactor?.saveDraftAtBackButtonTapIfNoEmpty(request: AddressBookFlow.RoutePayload.Request()) },
                      secondButtonCompletion: {
                          self.displayRouteBack(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel()) }
            )

        } else {
            showAlert(title: viewModel.title,
                      message: viewModel.text,
                      firstButtonTitle: viewModel.buttonTitle ?? "Ok")
        }

    }
}

// MARK: - NewEmailCreateViewOutput, NewEmailCreateUpperViewOutput
extension NewEmailCreateController: NewEmailCreateViewOutput {

    func didTapSomeDropdownMenuTitle(titleViewModel: NewEmailCreateModels.oneTitleOfDropdownMenu) {
        if titleViewModel.enumCaseOfDropdownMenu == .pickFotoFromGallary {
            self.chooseImagePicker(source: .photoLibrary)
        } else {
            interactor?.didTapSomeDropdownMenuTitle(request: NewEmailCreateFlow.OnDropdownMenuTitle.Request(enumCase: titleViewModel.enumCaseOfDropdownMenu))
        }
    }

    func didTapAtXButtonAtCloudAttachment(_ viewModel: CloudEmailAttachmentViewModel) {
        interactor?.didTapXButtonAttachedCloud(
            request: NewEmailCreateFlow.OnXButtonAttachedCloud.Request(id: viewModel.id))
    }

    func onChangeTextInTextView(_ viewModel: TextViewCellViewModel, currentText: String) {
        interactor?.useTextOfTextViewCell(request: NewEmailCreateFlow.OnTextViewDidChange.Request(
            textInEmailTextViewCell: currentText))
    }

    func useCurrent(toEmailAdressText: String?,
                    copyEmailAdressesText: String?,
                    textThemeOfEmailText: String?,
                    isEmptyViewVisible: Bool) {
        interactor?.useTextAtToCopyThemeFields(request: NewEmailCreateFlow.Update.Request(
                toEmailAddress: toEmailAdressText,
                copyEmailAddresses: copyEmailAdressesText,
                subjectOfMessage: textThemeOfEmailText,
                isEmptyViewVisible: isEmptyViewVisible))
    }

    func didTapChevronOpenCloseMoreEmails(isEmptyViewVisible: Bool) {
        interactor?.didTapChevronOpenCloseMoreAdressesButton(
            request: NewEmailCreateFlow.OnChevronTapped.Request(isEmptyViewVisible: isEmptyViewVisible))
    }

    func didTapAtCloudAttachment(_ viewModel: CloudEmailAttachmentViewModel){
        interactor?.didTapAtFileOrFoto(request: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Request(cloudEmailViewModel: viewModel))
    }

    func didTapAtFoto(_ viewModel: FotoCellViewModel) {
        interactor?.didTapAtFileOrFoto(request: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Request(fotoViewModel: viewModel))
    }

    func didTapAtDownloadIcon(_ viewModel: FotoCellViewModel) {
        interactor?.didTapDownloadIcon(request: NewEmailCreateFlow.OnDownloadIconOrToSaveAttachedFile.Request())
    }

    func didTapAtQuattroIcon(_ viewModel: FotoCellViewModel) {
        interactor?.didTapQuattroIcon(request: NewEmailCreateFlow.OnQuattroIcon.Request())
    }

    func didTapSendButton(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel) {
        interactor?.didTapSendButton(request: NewEmailCreateFlow.OnSendButton.Request())
    }

    func didTapAddressBookIcon(toOrCopyFieldTapped: NewEmailCreateUpperModel.AddressField) {
        //remember field for adding picked addresses to it
        switch toOrCopyFieldTapped {
        case .toField:
            isUserNowTakingAddressesForCopyField = false
        case .copyField:
            isUserNowTakingAddressesForCopyField = true
        }

        interactor?.didTapAddressBookIcon(request: NewEmailCreateFlow.OnAddressIcon.Request(
            isUserNowTakingAddressesForCopyField: isUserNowTakingAddressesForCopyField))
    }
}



// MARK: - UIDocumentPickerDelegate
extension NewEmailCreateController: UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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


// MARK: - AddressBookGetAdressesDelegate
extension NewEmailCreateController: AddressBookGetAdressesDelegate {

    func getEmailAdresses(pickedEmailAdresses: [String]) {
        switch isUserNowTakingAddressesForCopyField {
        case true:
            interactor?.addPickedEmailsFromAddressBook(
                toOrCopyField: .copyField,
                pickedEmailAdresses: pickedEmailAdresses)
        case false:
            interactor?.addPickedEmailsFromAddressBook(
                toOrCopyField: .toField,
                pickedEmailAdresses: pickedEmailAdresses)
        }
    }
}
