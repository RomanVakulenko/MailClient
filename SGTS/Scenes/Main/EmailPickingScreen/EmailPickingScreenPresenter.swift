//
//  EmailPickingScreenPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import UIKit
import DifferenceKit
import SnapKit

protocol EmailPickingScreenPresentationLogic {
    func presentUpdate(response: EmailPickingScreenFlow.Update.Response)
    func presentWaitIndicator(response: EmailPickingScreenFlow.OnWaitIndicator.Response)
    func presentAlert(response: EmailPickingScreenFlow.AlertInfo.Response)
    func didTapBackArrow()
    func presentDropdownMenu(response: EmailPickingScreenFlow.OnDropdownMenu.Response)
    func presentRouteToMovePickedEmailsScreen(response: EmailPickingScreenFlow.OnMoveToTitleOfDropdownMenu.Response)
    func presentRouteToMailStartScreen(response: EmailPickingScreenFlow.RoutePayload.Response)
}


final class EmailPickingScreenPresenter: EmailPickingScreenPresentationLogic {

    enum Constants {
        static let mainImageWidthHeight: CGFloat = 45
        static let leftRightInset: CGFloat = 8
        static let insideCellSpacingAndBorderWidth: CGFloat = 4
        static let iconExtWidth: CGFloat = 12
    }

    // MARK: - Public properties

    weak var viewController: EmailPickingScreenDisplayLogic?

    // MARK: - Public methods
    func didTapBackArrow() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToMailStartScreen(viewModel: EmailPickingScreenFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToMailStartScreen(response: EmailPickingScreenFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToMailStartScreen(viewModel: EmailPickingScreenFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToMovePickedEmailsScreen(response: EmailPickingScreenFlow.OnMoveToTitleOfDropdownMenu.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToMovePickedEmailsScreen(viewModel: EmailPickingScreenFlow.RoutePayload.ViewModel())
        }
    }


    func presentDropdownMenu(response: EmailPickingScreenFlow.OnDropdownMenu.Response) {
        let titlesOfDropdownMenu = response.dropDownMenuTitleCases.map { titleCase in
            EmailPickingScreenModel.oneTitleOfDropdownMenu(
                enumCaseOfDropdownMenu: titleCase,
                attributedString: NSAttributedString(
                    string: titleCase.getTitle(),
                    attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)
            )
        }

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayThreeDotsDropdownMenu(
                viewModel: EmailPickingScreenFlow.OnDropdownMenu.ViewModel(dropdownMenuTitlesViewModel: titlesOfDropdownMenu))
        }
    }


    func presentUpdate(response: EmailPickingScreenFlow.Update.Response) {
        if response.pickedEmailIds.count == 0 {
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.displayRouteToMailStartScreen(viewModel: EmailPickingScreenFlow.RoutePayload.ViewModel())
            }
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var tableItems: [AnyDifferentiable] = []
            var dictEmailMessage: Dictionary<Int,EmailCellViewModel> = [:]

            let backViewColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

            let group = DispatchGroup()
            var lock = os_unfair_lock_s()

            for (index, oneMailForDisplay) in response.mailsForDisplay.enumerated() {
                group.enter()
                makeOneEmailCell(isAllEmailsBoxDidTap: response.isAllEmailsBoxDidTap,
                                 pickedEmailIds: response.pickedEmailIds,
                                 mailsFromDatabaseCount: response.mailsForDisplay.count,
                                 oneMailForDisplay: oneMailForDisplay,
                                 backViewColor: backViewColor,
                                 index: index) { (emailCellViewModel, index) in
                    os_unfair_lock_lock(&lock)
                    dictEmailMessage[index] = emailCellViewModel //чтобы одновременного обращения к словарю не было
                    os_unfair_lock_unlock(&lock)
                    group.leave()
                }
            }

            group.notify(queue: DispatchQueue.global()) { [weak self] in
                guard let self = self else { return }

                for index in 0..<dictEmailMessage.count {
                    if let emailCellVM = dictEmailMessage[index] {
                        tableItems.append(AnyDifferentiable(emailCellVM))
                    }
                }

                var pickedEmailsCount = response.pickedEmailIds.count
                if response.isAllEmailsBoxDidTap {
                    pickedEmailsCount = response.mailsForDisplay.count
                }

                let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD
                let screenTitle = NSAttributedString(
                    string: "\(pickedEmailsCount)",
                    attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)
                let archiveNavBarIcon = Theme.shared.isLight ? UIHelper.Image.archiveIcon24x24L : UIHelper.Image.archiveIcon24x24D
                let trashNavBarIcon = Theme.shared.isLight ? UIHelper.Image.trashIcon24x24L : UIHelper.Image.trashIcon24x24D
                let unreadNavBarIcon = Theme.shared.isLight ? UIHelper.Image.emailPickingScreenUnreadNavBarIcon24x24L : UIHelper.Image.emailPickingScreenUnreadNavBarIcon24x24D
                let threeDotsNavBarIcon = Theme.shared.isLight ? UIHelper.Image.emailPickingScreenThreeDotsNavBarIcon24x24L : UIHelper.Image.emailPickingScreenThreeDotsNavBarIcon24x24D
                let backArrow = Theme.shared.isLight ? UIHelper.Image.backArrow16pxL : UIHelper.Image.backArrow16pxD
                let backNavBarButtonColor = Theme.shared.isLight ? UIHelper.Color.grayAlpha06 : UIHelper.Color.grayRegularD
                backArrow.withTintColor(backNavBarButtonColor)

#warning("из-за завершения проекта этот код не был дописан по согласованию - а так должно было бы быть еще 3 шт: ...NotCheckedBoxD, ...сheckedBoxL, ...сheckedBoxD")
                let checkBoxButtonImage = Theme.shared.isLight ? UIHelper.Image.emailPickedScreenNotCheckedBoxL : UIHelper.Image.emailPickedScreenNotCheckedBoxL //потом добавить для D
                let checkBoxTitle = NSAttributedString(
                    string: getString(.emailPickingScreenCheckBoxTitlePickAll),
                    attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular14 : UIHelper.Attributed.blackMiddleLRobotoRegular14) //потом добавить для D
                let tabBarTitle = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: response.typeOfMessage).0
                let tabBarImage = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: response.typeOfMessage).1
                let tabBarSelectedImage = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: response.typeOfMessage).2

                DispatchQueue.main.async { [weak self] in
                    guard let self else {return}

                    self.viewController?.displayUpdate(viewModel: EmailPickingScreenFlow.Update.ViewModel(
                        backViewColor: backViewColor,
                        leftBarButtonImage: backArrow,
                        backNavBarButtonColor: backNavBarButtonColor,
                        screenTitle: screenTitle,

                        archiveNavBarIcon: archiveNavBarIcon,
                        trashNavBarIcon: trashNavBarIcon,
                        unreadNavBarIcon: unreadNavBarIcon,
                        threeDotsNavBarIcon: threeDotsNavBarIcon,

                        checkBoxButtonImage: checkBoxButtonImage,
                        checkBoxTitle: checkBoxTitle,
                        separatorColor: separatorColor,
                        tabBarTitle: tabBarTitle,
                        tabBarImage: tabBarImage,
                        tabBarSelectedImage: tabBarSelectedImage,
                        items: tableItems))
                }
            }
        }
    }

    func presentAlert(response: EmailPickingScreenFlow.AlertInfo.Response) {
        var title = getString(.error)
        var text = ""

        switch response.alertAt {
        case .movedSuccessfully:
            title = getString(.someNotification)
            text = getString(.movedSuccessfully)
        case .movingToSentFolder:
            text = getString(.errorAtMovingToSentFolder)
        case .movingToDraftsFolder:
            text = getString(.errorAtMovingToDraftsFolder)
        case .movingToDeletedFolder:
            text = getString(.errorAtMovingToDeletedFolder)
        case .movingToArchivedFolder:
            text = getString(.errorAtMovingToArchivedFolder)
        case .gettingMail:
            text = getString(.errorAtGettingMail)
        case .areYorReallyWantToDelete:
            title = getString(.someNotification)
            text = getString(.doYouWantToDelete)
        case .areYorReallyWantToArchive:
            title = getString(.someNotification)
            text = getString(.doYouWantToArchive)
        default: text = getString(.error)
        }

        let firstButtonTitle = getString(.closeAction)
        let secondButtonTitle = getString(.сancelTitle)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(viewModel: EmailPickingScreenFlow.AlertInfo.ViewModel(
                title: title,
                text: text,
                firstButtonTitle: firstButtonTitle,
                secondButtonTitle: secondButtonTitle))
        }
    }

    func presentWaitIndicator(response: EmailPickingScreenFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: EmailPickingScreenFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }

    // MARK: - Private methods

    private func makeOneEmailCell(isAllEmailsBoxDidTap: Bool,
                                  pickedEmailIds: Set<String>,
                                  mailsFromDatabaseCount: Int, 
                                  oneMailForDisplay: EmailMessageWithNeededProperties,
                                  backViewColor: UIColor,
                                  index: Int,
                                  completion: @escaping (EmailCellViewModel, Int) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let emailCellBackColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
            let newEmailCellBackColor = Theme.shared.isLight ? UIHelper.Color.almostWhiteL2 : UIHelper.Color.almostBlackD2

            let backCellViewColor = oneMailForDisplay.isNewEmailIconDisplaying ?? false ? newEmailCellBackColor : emailCellBackColor

            var avatarImage = UIImage()

            if isAllEmailsBoxDidTap {
                avatarImage = UIHelper.Image.emailPickedScreenAvatarBoth
            } else if pickedEmailIds.contains(oneMailForDisplay.id) {
                avatarImage = UIHelper.Image.emailPickedScreenAvatarBoth
            } else {
                avatarImage = Theme.shared.isLight ? UIHelper.Image.notPickedAvatarL : UIHelper.Image.notPickedAvatarD
            }

            var allIconViewsForOneCell = [UIImageView]()
            let semaphore = DispatchSemaphore(value: 0) //кол-во потоков(0), кот. имеют доступ к ресурсу

            self.fillIconsFor(oneEmail: oneMailForDisplay) { iconsInOneCell in
                allIconViewsForOneCell = iconsInOneCell
                semaphore.signal() //Increment the counting semaphore (имеет доступ 1 поток)
            }

            semaphore.wait() //Decrement the counting semaphore (доступ для 0 потоков)
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM"
                dateFormatter.locale = Locale(identifier: "ru_RU")
                let stringDate = dateFormatter.string(from: oneMailForDisplay.receivedDate)

                // MARK: - Collection Items
                let attributesForAttachmentName = Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14

                var collectionOfAttachments: [AnyDifferentiable] = []
                var widthsOfAttachmentsFileNames = [CGFloat]()

                if let arrayOfAttachmentNamesAndExt = oneMailForDisplay.arrayOfAttachmentNamesAndExt {
                    for oneAttachmentName in arrayOfAttachmentNamesAndExt {
                        let (oneAttachmentCell, width) = makeAttachmentVM(
                            fileName: oneAttachmentName,
                            cloudBackColor: emailCellBackColor,
                            attributesForString: attributesForAttachmentName)

                        collectionOfAttachments.append(oneAttachmentCell)
                        widthsOfAttachmentsFileNames.append(width)
                    }
                }

                let emailSender = NSAttributedString(string: oneMailForDisplay.senderEmail, attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoSemibold17 : UIHelper.Attributed.whiteStrongRobotoSemibold17)

                let emailTitle = NSAttributedString(string: oneMailForDisplay.subject, attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoMedium14 : UIHelper.Attributed.whiteDarkDRobotoMedium14)

                let emailText = NSAttributedString(string: oneMailForDisplay.body, attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14)

                let emailDate = NSAttributedString(string: stringDate, attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular14: UIHelper.Attributed.grayRegularDRobotoRegular14)

                let newEmailCloudBackColor = UIHelper.Color.blue

                let newEmailCloudTitle = NSAttributedString(string: getString(.mailStartScreenCloudNewEmailTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.whiteRobotoBold11: UIHelper.Attributed.whiteStrongRobotoBold11)

                let oneEmailCell = EmailCellViewModel(
                    id: oneMailForDisplay.id,
                    backColor: backCellViewColor,
                    avatarImage: avatarImage,
                    emailSender: emailSender,
                    emailTitle: emailTitle,
                    allIconViewsForOneCell: allIconViewsForOneCell,
                    emailText: emailText,
                    emailDate: emailDate,
                    isNewEmailIconDisplaying: oneMailForDisplay.isNewEmailIconDisplaying ?? false,
                    newEmailCloudBackColor: newEmailCloudBackColor,
                    newEmailCloudTitle: newEmailCloudTitle,
                    isPersonalToUserIconDisplaying: oneMailForDisplay.isPersonalToUserIconDisplaying ?? false,
                    isEmportantEmailIndicatorDisplaying: oneMailForDisplay.isEmportantEmailIndicatorDisplaying ?? false,
                    isExternalEmailIconDisplaying: oneMailForDisplay.isExternalEmailIconDisplaying ?? false,
                    isAttachmentIconDisplaying: oneMailForDisplay.isAttachmentIconDisplaying ?? false,
                    insets: UIEdgeInsets(top: UIHelper.Margins.medium16px,
                                         left: UIHelper.Margins.medium16px,
                                         bottom: UIHelper.Margins.medium16px,
                                         right: UIHelper.Margins.medium16px),
                    separatorInset: UIEdgeInsets(),
                    items: collectionOfAttachments,
                    widths: widthsOfAttachmentsFileNames)
                completion(oneEmailCell, index)
            }
        }
    }

    private func fillIconsFor(oneEmail: EmailMessageWithNeededProperties,
                              completion: @escaping ([UIImageView]) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard self != nil else { return }
            var allIconViewsForOneCell = [UIImageView]()

            if oneEmail.isPersonalToUserIconDisplaying == true {
                allIconViewsForOneCell.append(UIImageView(image: UIHelper.Image.emailUserIcon))
            }
            if oneEmail.isEmportantEmailIndicatorDisplaying == true {
                allIconViewsForOneCell.append(UIImageView(image: UIHelper.Image.emailImportantIcon))
            }
            if oneEmail.isExternalEmailIconDisplaying == true {
                allIconViewsForOneCell.append(UIImageView(image: UIHelper.Image.emailExternalIcon))
            }
            if oneEmail.isAttachmentIconDisplaying == true {
                allIconViewsForOneCell.append(UIImageView(image: UIHelper.Image.emailAttachmentIcon))
            }

            completion(allIconViewsForOneCell)
        }
    }

    private func makeAttachmentVM(fileName: String,
                                  cloudBackColor: UIColor,
                                  attributesForString: [NSAttributedString.Key : Any]) -> (AnyDifferentiable, CGFloat) {

        let nameWithoutExtension = fileName.components(separatedBy: ".").first ?? ""
        let name = NSAttributedString(string: nameWithoutExtension, attributes: attributesForString)
        var textLenght = CGFloat()

        if fileName.count > GlobalConstants.cloudAttachmentTextLength20Сhars {
            textLenght = GlobalConstants.cloudAttachmentTextWidthPoints
        } else {
            textLenght = CGFloat(name.size().width)
        }
        let oneCellWidht = (Constants.leftRightInset * 2) + Constants.iconExtWidth + Constants.insideCellSpacingAndBorderWidth + textLenght

        let fileExtension = fileName.components(separatedBy: ".").last ?? ""
        let iconOfFileExtension = ImageManager.getFileIcon(for: fileExtension)

        let attachmentsVM = CloudEmailAttachmentViewModel(
            id: fileName,
            filenameWithoutExt: name,
            filenameWithExt: nil,
            backColor: cloudBackColor,
            borderColor: Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD,
            attachmentIconOfCloud: iconOfFileExtension,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        return (AnyDifferentiable(attachmentsVM), oneCellWidht)
    }
}

// MARK: - EmailPickingScreenModel.DropdownMenuTitle

extension EmailPickingScreenModel.DropdownMenuTitle {
    func getTitle() -> String {
        switch self {
        case .reply:
            return getString(.reply)
        case .replyToAll:
            return getString(.replyToAll)
        case .forward:
            return getString(.forward)
        case .moveTo:
            return getString(.moveEmailTo)
        case .markAsRead:
            return getString(.markEmailAsRead)
        case .markAsUnread:
            return getString(.markEmailAsUnread)
        }
    }
}
