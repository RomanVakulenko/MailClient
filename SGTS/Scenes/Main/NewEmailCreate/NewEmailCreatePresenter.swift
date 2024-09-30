//
//  NewEmailCreatePresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import UIKit
import DifferenceKit

protocol NewEmailCreatePresentationLogic {
    func presentUpdate(response: NewEmailCreateFlow.Update.Response)

    func presentDropdownMenu(response: NewEmailCreateFlow.OnDropdownMenu.Response)

    func presentWaitIndicator(response: NewEmailCreateFlow.OnWaitIndicator.Response)
    func presentAlert(response: NewEmailCreateFlow.AlertInfo.Response)
    func presentRouteToFullScreenImage(response: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Response)
    func presentRouteToSaveDialog(response: NewEmailCreateFlow.OnDownloadIconOrToSaveAttachedFile.Response)
    func presentFileDialog(response: NewEmailCreateFlow.OnAttachBarButtonIcon.Response)
    func presentRouteToAddressBookScreen(response: NewEmailCreateFlow.OnAddressIcon.Response)
    func presentRouteToOpenData(response: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Response)
    func presentRouteBack(response: NewEmailCreateFlow.RoutePayload.Response)

    func presentSending(response: NewEmailCreateFlow.RoutePayload.Response)
}


final class NewEmailCreatePresenter: NewEmailCreatePresentationLogic {

    enum Constants {
        static let leftRightInset: CGFloat = 8
        static let insideCellSpacingAndBorderWidth: CGFloat = 1 + 2 + 2 + 1
        static let iconExtWidth: CGFloat = 12
        static let xButtonAndLeadingOffset: CGFloat = 2 + 14
    }

    // MARK: - Public properties

    weak var viewController: NewEmailCreateDisplayLogic?

    // MARK: - Public methods

    func presentDropdownMenu(response: NewEmailCreateFlow.OnDropdownMenu.Response) {
        let titlesOfDropdownMenu = response.dropDownMenuTitleCases.map { titleCase in
            NewEmailCreateModels.oneTitleOfDropdownMenu(
                enumCaseOfDropdownMenu: titleCase,
                attributedString: NSAttributedString(
                    string: titleCase.getTitle(),
                    attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14
                )
            )
        }

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayDropdownMenuAtNavBarIcons(viewModel: NewEmailCreateFlow.OnDropdownMenu.ViewModel(
                menuID: response.menuID,
                dropdownMenuTitlesViewModel: titlesOfDropdownMenu)
            )
        }
    }

    func presentRouteToOpenData(response: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToOpenData(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteBack(response: NewEmailCreateFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBack(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel())
        }
    }

    func presentFileDialog(response: NewEmailCreateFlow.OnAttachBarButtonIcon.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayFileDialog(
                viewModel: NewEmailCreateFlow.OnAttachBarButtonIcon.ViewModel())
        }
    }

    func presentRouteToAddressBookScreen(response: NewEmailCreateFlow.OnAddressIcon.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToAddressBookScreen(viewModel: NewEmailCreateFlow.OnAddressIcon.ViewModel())
        }
    }

    func presentRouteToSaveDialog(response: NewEmailCreateFlow.OnDownloadIconOrToSaveAttachedFile.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSaveDialog(
                viewModel: NewEmailCreateFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToFullScreenImage(response: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToOpenImage(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel())
        }
    }

    func presentSending(response: NewEmailCreateFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displaySending(
                viewModel: NewEmailCreateFlow.RoutePayload.ViewModel())
        }
    }

    func presentUpdate(response: NewEmailCreateFlow.Update.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let screenTitle = NSAttributedString(string: getString(.newEmailCreateScreenTitle),
                                             attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)

        var views: [AnyDifferentiable] = []
        views.append(makeUpperVM(response: response,
                                 separatorColor: separatorColor,
                                 backColor: backColor,
                                 isEmptyViewVisible: response.isEmptyViewVisible))

        if response.hasAttachment,
           let namesOfAttachedFiles = response.arrayOfAttachmentNamesWithExt {
            views.append(makeAttachmentVM(
                fileNames: namesOfAttachedFiles,
                isImageInsideAttachment: response.isImagePreviewable))
        }

        var itemsViewModelsOfCells: [AnyDifferentiable] = []

        itemsViewModelsOfCells.append(makeTextViewCellVM(
            textInTextViewCell: response.textInEmailTextViewCell ?? "",
            signature: response.signature))

        if response.isImagePreviewable {
            itemsViewModelsOfCells.append(makeSeparatorCellVM())
            itemsViewModelsOfCells.append(makeFotoCellTitleVM())

            if let attachmentsWithFotos = response.arrayOfDictionaryNameAndDataPreviewable {
                itemsViewModelsOfCells.append(contentsOf: makeFotoCellVM(attachmentsWithFotos: attachmentsWithFotos))
            }
        }

        let attachmentNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.attachmentNavBarIcon18x20L : UIHelper.Image.attachmentNavBarIcon18x20D)
        let planeNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.newEmailCreatePlaneNavBarIconL : UIHelper.Image.newEmailCreatePlaneNavBarIconD)
        let threeDotsIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.threeDotsNavBarIcon4x16L : UIHelper.Image.threeDotsNavBarIcon4x16D)

        let navBar = CustomNavBar(title: screenTitle,
                            isLeftBarButtonEnable: true,
                            isLeftBarButtonCustom: false,
                            leftBarButtonCustom: nil,
                            rightBarButtons: [threeDotsIcon, planeNavBarIcon, attachmentNavBarIcon])

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: NewEmailCreateFlow.Update.ViewModel(
                navBar: navBar,
                backViewColor: backColor,
                separatorColor: separatorColor,
                hasAttachment: response.hasAttachment,
                views: views,
                items: itemsViewModelsOfCells))
        }
    }

    func presentAlert(response: NewEmailCreateFlow.AlertInfo.Response) {
        var title = getString(.error)
        var text = ""
        
        switch response.alertAt {
        case .saveAsDraftOrNot:
            title = getString(.someNotification)
            text = getString(.newEmailCreateSavingDraft)
        case .savingAsDraft:
            title = getString(.someNotification)
            text = getString(.newEmailCreateSavingDraft)
        case .fillingFieldTo:
            text = getString(.newEmailCreateAlertAtToField)
        case .fillingFieldCopy:
            text = getString(.newEmailCreateAlertAtCopyField)
        case .sendingEmailIsOk:
            title = getString(.someNotification)
            text = getString(.newEmailCreateSendingOk)
        case .sendingEmailFailed:
            text = getString(.newEmailCreateSendingFailed)
        case .sendingEmailEmptyToField:
            text = getString(.newEmailCreateToFieldIsEmpty)
        case .attachingFiles:
            text = getString(.newEmailCreateFileSizeIsBiggerThanLimit)
        case .gettingAllContactListItems:
            text = getString(.addressBookCantGetAddressesAndNames)
        default:
            text = getString(.newEmailCreateNotAbleToAddFiles)
        }

        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(
                viewModel: NewEmailCreateFlow.AlertInfo.ViewModel(title: title, text: text, buttonTitle: buttonTitle))
        }
    }

    func presentWaitIndicator(response: NewEmailCreateFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: NewEmailCreateFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }

    // MARK: - Private methods

    private func makeUpperVM(response: NewEmailCreateFlow.Update.Response,
                             separatorColor: UIColor,
                             backColor: UIColor,
                             isEmptyViewVisible: Bool) -> AnyDifferentiable {

        let fromLabel = NSAttributedString(string: getString(.newEmailCreateUpperViewFromTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)
        let toLabel = NSAttributedString(string: getString(.newEmailCreateUpperViewToTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)
        let copyLabel = NSAttributedString(string: getString(.newEmailCreateUpperViewCopyTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)
        let titleThemeOfEmail = NSAttributedString(string: getString(.newEmailCreateUpperViewThemeTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)


        ///user's emailAddress
        let fromEmailAdressText = NSAttributedString(string: response.fromEmailAddressText, attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)

        var recipientEmails = ""
        if let recipientEmailAddress = response.toEmailAddress {
            recipientEmails = recipientEmailAddress
        } else {
            recipientEmails = response.toEmailAddress ?? ""
        }
        let copyEmailAdressesText = response.copyEmailAdresses

        let toCopyTextColor = Theme.shared.isLight ? UIHelper.Color.blackMiddleL : UIHelper.Color.whiteStrong

        var emailSubject = ""
        if let textThemeOfEmail = response.subjectOfMessage {
            switch response.emailType {
            case .newEmail:
                emailSubject = textThemeOfEmail
            case .reply, .replyAll:
                if !textThemeOfEmail.contains(substring: "Re: ") {
                    emailSubject = "Re: " + textThemeOfEmail
                } else {
                    emailSubject += textThemeOfEmail
                }
            case .forward:
                if !textThemeOfEmail.contains(substring: "Fwd: ") {
                    emailSubject = "Fwd: " + textThemeOfEmail
                } else {
                    emailSubject += textThemeOfEmail
                }
            }
        }

        let toRectIcon = Theme.shared.isLight ? UIHelper.Image.newEmailCreateRectTemplateAvatarIconL : UIHelper.Image.newEmailCreateRectTemplateAvatarIconD
        let copyRectIcon = Theme.shared.isLight ? UIHelper.Image.newEmailCreateRectTemplateAvatarIconL : UIHelper.Image.newEmailCreateRectTemplateAvatarIconD

        let chevronButtonDown = Theme.shared.isLight ? UIHelper.Image.chevronDownL : UIHelper.Image.chevronDownD

        let upperVM = NewEmailCreateUpperModel.ViewModel(
            backColor: backColor,
            fromLabel: fromLabel,
            toLabel: toLabel,
            copyLabel: copyLabel,
            titleThemeOfEmail: titleThemeOfEmail,
            fromEmailAdressText: fromEmailAdressText,
            toEmailAddressesText: recipientEmails,
            toRectIcon: toRectIcon,
            toCopyTextColor: toCopyTextColor,
            copyEmailAdressesText: copyEmailAdressesText,
            copyRectIcon: copyRectIcon,
            textThemeOfEmail: emailSubject,
            chevronButtonDown: chevronButtonDown,
            separatorColor: separatorColor,
            insets: .zero,
            isEmptyViewVisible: isEmptyViewVisible
        )
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

// MARK: - NewEmailCreateModel.DropdownMenuTitle

extension NewEmailCreateModels.DropdownMenuTitle {
    func getTitle() -> String {
        switch self {
        case .deleteMail:
            return getString(.newEmailCreateThreeDotsMenuDeleteLabel)
        case .saveDraft:
            return getString(.newEmailCreateThreeDotsMenuSaveDraftLabel)
        case .attachFile:
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
