//
//  UserProfileSendReportPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.07.2024.
//

import UIKit
import DifferenceKit

protocol UserProfileSendReportPresentationLogic {
    func presentUpdate(response: UserProfileSendReportFlow.Update.Response)

    func presentDropdownMenu(response: UserProfileSendReportFlow.OnDropdownMenu.Response)

    func presentWaitIndicator(response: UserProfileSendReportFlow.OnWaitIndicator.Response)
    func presentAlert(response: UserProfileSendReportFlow.AlertInfo.Response)
    func presentRouteToFullScreenImage(response: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Response)
    func presentRouteToSaveDialog(response: UserProfileSendReportFlow.OnDownloadIconOrToSaveAttachedFile.Response)
    func presentFileDialog(response: UserProfileSendReportFlow.OnAttachBarButtonIcon.Response)
    func presentRouteToAddressBookScreen(response: UserProfileSendReportFlow.OnAddressIcon.Response)
    func presentRouteToOpenData(response: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Response)
    func presentSending(response: UserProfileSendReportFlow.RoutePayload.Response)
    func presentRouteBack(response: UserProfileSendReportFlow.RoutePayload.Response)
}


final class UserProfileSendReportPresenter: UserProfileSendReportPresentationLogic {

    enum Constants {
        static let leftRightInset: CGFloat = 8
        static let insideCellSpacingAndBorderWidth: CGFloat = 1 + 2 + 2 + 1
        static let iconExtWidth: CGFloat = 12
        static let xButtonAndLeadingOffset: CGFloat = 2 + 14
    }

    // MARK: - Public properties

    weak var viewController: UserProfileSendReportDisplayLogic?

    // MARK: - Public methods

    func presentRouteBack(response: UserProfileSendReportFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBack(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel())
        }
    }

    func presentSending(response: UserProfileSendReportFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displaySending(
                viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel())
        }
    }

    func presentDropdownMenu(response: UserProfileSendReportFlow.OnDropdownMenu.Response) {
        let titlesOfDropdownMenu = response.dropDownMenuTitleCases.map { titleCase in
            UserProfileSendReportModels.oneTitleOfDropdownMenu(
                enumCaseOfDropdownMenu: titleCase,
                attributedString: NSAttributedString(
                    string: titleCase.getTitle(),
                    attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14
                )
            )
        }

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayDropdownMenuAtNavBarIcons(viewModel: UserProfileSendReportFlow.OnDropdownMenu.ViewModel(dropdownMenuTitlesViewModel: titlesOfDropdownMenu)
            )
        }
    }

    func presentRouteToOpenData(response: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToOpenData(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel())
        }
    }

    func presentFileDialog(response: UserProfileSendReportFlow.OnAttachBarButtonIcon.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayFileDialog(
                viewModel: UserProfileSendReportFlow.OnAttachBarButtonIcon.ViewModel())
        }
    }

    func presentRouteToAddressBookScreen(response: UserProfileSendReportFlow.OnAddressIcon.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToAddressBookScreen(viewModel: UserProfileSendReportFlow.OnAddressIcon.ViewModel())
        }
    }

    func presentRouteToSaveDialog(response: UserProfileSendReportFlow.OnDownloadIconOrToSaveAttachedFile.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSaveDialog(
                viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToFullScreenImage(response: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToOpenImage(viewModel: UserProfileSendReportFlow.RoutePayload.ViewModel())
        }
    }


    func presentUpdate(response: UserProfileSendReportFlow.Update.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let screenTitle = NSAttributedString(string: getString(.userProfileSendReportTitleAndSubject),
                                             attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)

        var views: [AnyDifferentiable] = []
        views.append(makeUpperVM(response: response,
                                 separatorColor: separatorColor,
                                 backColor: backColor))

        if response.hasAttachment,
           let namesOfAttachedFiles = response.arrayOfAttachmentNamesWithExt {
            views.append(makeAttachmentVM(fileNames: namesOfAttachedFiles,
                                          isImageInsideAttachment: response.isImageInsideAttachment))
        }

        var itemsViewModelsOfCells: [AnyDifferentiable] = []
        itemsViewModelsOfCells.append(makeTextViewCellVM(
            textInTextViewCell: response.textInEmailTextViewCell ?? "",
            signature: response.signature))

        if response.isImageInsideAttachment {
            itemsViewModelsOfCells.append(makeSeparatorCellVM())
            itemsViewModelsOfCells.append(makeFotoCellTitleVM())

            if let attachmentsWithFotos = response.arrayOfDictionaryNameAndDataPreviewable {
                itemsViewModelsOfCells.append(contentsOf: makeFotoCellVM(attachmentsWithFotos: attachmentsWithFotos))
            }
        }

        let attachmentNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.attachmentNavBarIcon18x20L : UIHelper.Image.attachmentNavBarIcon18x20D)
        let planeNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.newEmailCreatePlaneNavBarIconL : UIHelper.Image.newEmailCreatePlaneNavBarIconD)

        let navBar = CustomNavBar(title: screenTitle,
                            isLeftBarButtonEnable: true,
                            isLeftBarButtonCustom: false,
                            leftBarButtonCustom: nil,
                            rightBarButtons: [planeNavBarIcon, attachmentNavBarIcon])

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: UserProfileSendReportFlow.Update.ViewModel(
                navBar: navBar,
                backViewColor: backColor,
                separatorColor: separatorColor,
                hasAttachment: response.hasAttachment,
                views: views,
                items: itemsViewModelsOfCells))
        }
    }

    func presentAlert(response: UserProfileSendReportFlow.AlertInfo.Response) {
        var title = getString(.error)
        var text = ""

        switch response.alertAt {
        case .fillingFieldTo:
            text = getString(.newEmailCreateAlertAtToField)
        case .fillingFieldCopy:
            text = getString(.newEmailCreateAlertAtCopyField)
        case .sendingEmailIsOk:
            title = getString(.someNotification) 
            text = getString(.newEmailCreateSendingOk)
        case .sendingEmailFailed:
            text = getString(.newEmailCreateSendingFailed)
        case .attachingFiles:
            text = getString(.newEmailCreateFileSizeIsBiggerThanLimit)
        default:
            text = getString(.newEmailCreateNotAbleToAddFiles)
        }

        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(
                viewModel: UserProfileSendReportFlow.AlertInfo.ViewModel(title: title, text: text, buttonTitle: buttonTitle))
        }
    }

    func presentWaitIndicator(response: UserProfileSendReportFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: UserProfileSendReportFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }

    // MARK: - Private methods

    private func makeUpperVM(response: UserProfileSendReportFlow.Update.Response,
                             separatorColor: UIColor,
                             backColor: UIColor) -> AnyDifferentiable {

        let subjectLabel = NSAttributedString(string: getString(.newEmailCreateUpperViewThemeTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)
        let toLabel = NSAttributedString(string: getString(.newEmailCreateUpperViewToTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)
        let copyLabel = NSAttributedString(string: getString(.newEmailCreateUpperViewCopyTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)

//        ///user's emailAddress
//        let fromEmailAdressText = NSAttributedString(string: response.userEmailAddress, attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06UnderlinedRobotoRegular14 : UIHelper.Attributed.whiteDarkDUnderlinedRobotoRegular14)

        let toCopyTextColor = Theme.shared.isLight ? UIHelper.Color.blackMiddleL : UIHelper.Color.whiteStrong

        let toRectIcon = Theme.shared.isLight ? UIHelper.Image.newEmailCreateRectTemplateAvatarIconL : UIHelper.Image.newEmailCreateRectTemplateAvatarIconD
        let copyRectIcon = Theme.shared.isLight ? UIHelper.Image.newEmailCreateRectTemplateAvatarIconL : UIHelper.Image.newEmailCreateRectTemplateAvatarIconD

        let upperVM = SendReportUpperModel.ViewModel(
            backColor: backColor,
            subjectLabel: subjectLabel,
            subjectText: response.subjectOfMessage,
            toLabel: toLabel,
            toEmailAddressesText: response.toEmailAddress,
            toRectIcon: toRectIcon,
            copyLabel: copyLabel,
            copyRectIcon: copyRectIcon,
            toCopyTextColor: toCopyTextColor,
            separatorColor: separatorColor,
            insets: .zero)
        return AnyDifferentiable(upperVM)
    }

    // MARK: - Attachment
    let emailCellBackColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

    private func makeAttachmentVM(fileNames: [String], isImageInsideAttachment: Bool) -> AnyDifferentiable {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let title = NSAttributedString(
            string: getString(.oneEmailDetailsAttachedFilesTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoSemiBold14 : UIHelper.Attributed.whiteStrongRobotoSemiBold14)
        let attributesForAttachmentName = Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14

        var collectionOfAttachments: [AnyDifferentiable] = []
        var widthsOfAttachmentsFileNames = [CGFloat]()

        for name in fileNames {
            let (oneAttachmentCell, width) = makeOneAttachmentVM(
                fileName: name,
                cloudBackColor: emailCellBackColor,
                attributesForString: attributesForAttachmentName,
                isImageInsideAttachment: isImageInsideAttachment)

            collectionOfAttachments.append(oneAttachmentCell)
            widthsOfAttachmentsFileNames.append(width)
        }

        let attachmentVM = OneEmailAttachmentViewModel(
            id: 0,
            backColor: backColor,
            attachmentTitle: title,
            insets:  UIEdgeInsets(top: UIHelper.Margins.medium8px,
                                  left: UIHelper.Margins.medium16px,
                                  bottom: UIHelper.Margins.medium8px,
                                  right: UIHelper.Margins.medium16px),
            items: collectionOfAttachments,
            widths: widthsOfAttachmentsFileNames)

        return AnyDifferentiable(attachmentVM)
    }

    private func makeOneAttachmentVM(fileName: String,
                                     cloudBackColor: UIColor,
                                     attributesForString: [NSAttributedString.Key : Any],
                                     isImageInsideAttachment: Bool) -> (AnyDifferentiable, CGFloat) {
        let nameWithoutExtension = fileName.components(separatedBy: ".").first ?? ""
        let name = NSAttributedString(string: nameWithoutExtension, attributes: attributesForString)
        var textLenght = CGFloat()

        if fileName.count > GlobalConstants.cloudAttachmentTextLength20Сhars {
            textLenght = GlobalConstants.cloudAttachmentTextWidthPoints
        } else {
            textLenght = CGFloat(name.size().width)
        }
        let oneCellWidht = (Constants.leftRightInset * 2) + Constants.iconExtWidth + Constants.insideCellSpacingAndBorderWidth + textLenght + Constants.xButtonAndLeadingOffset

        let fileExtension = fileName.components(separatedBy: ".").last ?? ""
        let iconOfFileExtension = ImageManager.getFileIcon(for: fileExtension)

        let attachmentsVM = CloudEmailAttachmentViewModel(
            id: fileName, 
            filenameWithoutExt: name,
            filenameWithExt: fileName,
            backColor: cloudBackColor,
            borderColor: Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD,
            attachmentIconOfCloud: iconOfFileExtension,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            xButton: Theme.shared.isLight ? UIHelper.Image.xButton14pxL : UIHelper.Image.xButton14pxD,
            isNewCreatingEmail: true)

        return (AnyDifferentiable(attachmentsVM), oneCellWidht)
    }

    private func makeTextViewCellVM(textInTextViewCell: String, signature: String) -> AnyDifferentiable {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        let attributeForTextViewText = Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular16 : UIHelper.Attributed.whiteDarkDRobotoRegular16
        let placeholder = NSAttributedString(string: getString(.newEmailCreateTextViewPlaceholder),
                                             attributes: attributeForTextViewText)

        var attributedText = NSAttributedString()
        //подписи нет и текстa нет - тогда ставим placeholder
        if signature == "" && textInTextViewCell == "" {
            attributedText = NSAttributedString(string: placeholder.string,
                                                attributes: attributeForTextViewText)
        } else if signature == "" && textInTextViewCell != "" {
            //подписи нет, а текст есть - тогда текст
            attributedText = NSAttributedString(string: textInTextViewCell,
                                                attributes: attributeForTextViewText)
        } else if signature != "" && textInTextViewCell == "" {
            //подпись есть и текстa нет - тогда ставим placeholder.string + "\n\n" + signature
            attributedText = NSAttributedString(string: placeholder.string + "\n\n" + signature,
                                                attributes: attributeForTextViewText)
        } else if signature != "" && textInTextViewCell != "" {
            //подпись есть и текст есть - тогда textInTextViewCell, который уже содержит "\n\n" + signature
            attributedText = NSAttributedString(string: textInTextViewCell,
                                                attributes: attributeForTextViewText)
        }

        let textCellVM = TextViewCellViewModel(
            id: 1,
            placeholder: placeholder,
            isCreatingNewEmail: true,
            isMakingSignature: false,
            attributedText: attributedText,
            backColor: backColor,
            isScrollEnabled: false,
            insets: UIEdgeInsets(top: UIHelper.Margins.small4px,
                                 left: 0,
                                 bottom: UIHelper.Margins.large24px,
                                 right: 0)
        )
        return AnyDifferentiable(textCellVM)
    }

    private func makeSeparatorCellVM() -> AnyDifferentiable {
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD
        let separatorCellVM = SeparatorCellViewModel(
            id: 0,
            separatorColor: separatorColor,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium16px, left: 0, bottom: 0, right: 0))
        return AnyDifferentiable(separatorCellVM)
    }

    private func makeFotoCellTitleVM() -> AnyDifferentiable {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        let title = NSAttributedString(
            string: getString(.oneEmailAttachedFotoTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoSemiBold14 : UIHelper.Attributed.whiteStrongRobotoSemiBold14)

        let fotoTextCellVM = TextFieldCellViewModel(
            id: 1,
            text: title,
            backColor: backColor,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium8px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: 0,
                                 right: UIHelper.Margins.medium16px)
        )
        return AnyDifferentiable(fotoTextCellVM)
    }
    
    private func makeFotoCellVM(attachmentsWithFotos: [[String : Data]]) -> [AnyDifferentiable] {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let downloadIcon = Theme.shared.isLight ? UIHelper.Image.oneEmailDetailsDownloadL : UIHelper.Image.oneEmailDetailsDownloadD
        let quattroIcon = Theme.shared.isLight ? UIHelper.Image.oneEmailDetailsQuattroL :UIHelper.Image.oneEmailDetailsQuattroD
        let separatorAndBorderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        var fotoCellVMs: [AnyDifferentiable] = [] //[] to silence warning of return AnyDifferentiable

        for (id, fileNameAndData) in attachmentsWithFotos.enumerated() {

            for (name, imageData) in fileNameAndData {
                let fileExtension = name.components(separatedBy: ".").last ?? ""
                let iconOfFileExtension = ImageManager.getFileIcon(for: fileExtension)

                let name = NSAttributedString(
                    string: name,
                    attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14)

                let image = UIImage(data: imageData) ?? UIImage()
                let fotoCellVM = FotoCellViewModel(id: id,
                                                   backColor: backColor,
                                                   borderColor: separatorAndBorderColor,
                                                   fotoImage: image,
                                                   fileIcon: iconOfFileExtension,
                                                   fileName: name,
                                                   downloadIcon: downloadIcon,
                                                   quattroIcon: quattroIcon,
                                                   insets: UIEdgeInsets(
                                                    top: UIHelper.Margins.medium8px,
                                                    left: UIHelper.Margins.medium16px,
                                                    bottom: 0,
                                                    right: UIHelper.Margins.medium16px))
                fotoCellVMs.append(AnyDifferentiable(fotoCellVM))
            }
        }

        return fotoCellVMs
    }
}

// MARK: - UserProfileSendReportModel.DropdownMenuTitle

extension UserProfileSendReportModels.DropdownMenuTitle {
    func getTitle() -> String {
        switch self {case .attachFile:
            return getString(.newEmailCreateAttachFileLabel)
        case .pickFotoFromGallary:
            return getString(.newEmailCreateChooseFоtoFromGalleryLabel)
        }
    }
}

//let mockJsonOneEmailData = """
//        {
//            "backColor": "#FF0000",
//            "oneEmailTitle": "Test Email",
//            "subTitleReceived": "Received",
//            "dateTimeSubTitle": "2023-03-21 10:30:00",
//            "attachmentIcon": "data:image/png;base64,iVBORw0KGg...",
//            "mainImage": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQPDxAQEB...",
//            "fromTitleAndAddress": "John Doe <johndoe@example.com>",
//            "chevronOpenCloseMoreAdresses": "data:image/png;base64,iVBORw0KGg...",
//            "toTitleAndAddresses": "Jane Doe <janedoe@example.com>",
//            "neededLinesForAllAdresses": 2,
//            "didSendTitle": "Sent",
//            "dateTimeDidSend": "2023-03-21 10:29:00",
//            "didReceiveTitle": "Received",
//            "dateTimeDidReceive": "2023-03-21 10:30:00"
//        }
//        """
