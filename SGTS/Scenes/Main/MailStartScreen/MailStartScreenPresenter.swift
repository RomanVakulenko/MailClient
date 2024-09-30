//
//  MailStartScreenPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import UIKit
import DifferenceKit
import SnapKit

protocol MailStartScreenPresentationLogic {
    func presentUpdate(response: MailStartScreenFlow.Update.Response)
    func presentWaitIndicator(response: MailStartScreenFlow.OnWaitIndicator.Response)
    func presentAlert(response: MailStartScreenFlow.AlertInfo.Response)

    func presentRouteToOneEmailDetailsScreen(response: MailStartScreenFlow.OnSelectItem.Response)
    func presentLongPressMoveToEmailPickingScreen(response: MailStartScreenFlow.OnLongPressGestureTap.Response)
    func presentRouteToNewEmailCreate(response: MailStartScreenFlow.RoutePayload.Response)
    func presentRouteToSideMenu(response: MailStartScreenFlow.RoutePayload.Response)
}


final class MailStartScreenPresenter: MailStartScreenPresentationLogic {

    enum Constants {
        static let mainImageWidthHeight: CGFloat = 45
        static let leftRightInset: CGFloat = 8
        static let insideCellSpacingAndBorderWidth: CGFloat = 4
        static let iconExtWidth: CGFloat = 12
    }

    // MARK: - Public properties
    weak var viewController: MailStartScreenDisplayLogic?

    // MARK: - Private properties
    private var cellWidths = [CGFloat]()

    // MARK: - Public methods

    func presentRouteToSideMenu(response: MailStartScreenFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSideMenu(viewModel: MailStartScreenFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToOneEmailDetailsScreen(response: MailStartScreenFlow.OnSelectItem.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToOneEmailDetailsScreen(viewModel: MailStartScreenFlow.OnSelectItem.ViewModel())
        }
    }

    func presentLongPressMoveToEmailPickingScreen(response: MailStartScreenFlow.OnLongPressGestureTap.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToEmailPickingScreen(viewModel: MailStartScreenFlow.OnLongPressGestureTap.ViewModel())
        }
    }

    func presentRouteToNewEmailCreate(response: MailStartScreenFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToNewEmailCreate(viewModel: MailStartScreenFlow.RoutePayload.ViewModel())
        }
    }

    func presentUpdate(response: MailStartScreenFlow.Update.Response) {

        var tableItems: [AnyDifferentiable] = []
        var amountOfUnreadMessages = Int()
        let backViewColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        var dictEmailMessage: Dictionary<Int,EmailCellViewModel> = [:]

        let group = DispatchGroup()
        var lock = os_unfair_lock_s()

        for (index, oneEmailMessage) in response.mailsFromDatabase.enumerated() {
            group.enter()
            makeOneEmailCell(oneEmailMessage: oneEmailMessage,
                             backViewColor: backViewColor,
                             index: index) { (emailCellViewModel, index) in
                os_unfair_lock_lock(&lock)
                dictEmailMessage[index] = emailCellViewModel //чтобы одновременного обращения к словарю не было
                os_unfair_lock_unlock(&lock)
                group.leave()
            }

        }

        group.notify(queue: DispatchQueue.global()) {[weak self] in
            guard let self = self else { return }

            for index in 0..<dictEmailMessage.count {
                if let emailCellVM = dictEmailMessage[index] {
                    tableItems.append(AnyDifferentiable(emailCellVM))
                }
            }

            let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD
            let sandwichNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.emailSandwichL : UIHelper.Image.emailSandwichD)

            let searchNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.searchIcon20L : UIHelper.Image.searchIcon20D)
            let addNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.addNavBarIconL : UIHelper.Image.addNavBarIconD)

            let tabBarTitle = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: response.typeOfMessage).0
            let title = NSAttributedString(
                string: tabBarTitle + " \(response.someMessagesFromTotal)/\(response.totalMessages)",
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)

            let navBar = CustomNavBar(title: title,
                                      isLeftBarButtonEnable: true,
                                      isLeftBarButtonCustom: true,
                                      leftBarButtonCustom: sandwichNavBarIcon,
                                      rightBarButtons: [addNavBarIcon, searchNavBarIcon])

            let tabBarImage = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: response.typeOfMessage).1
            let tabBarSelectedImage = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: response.typeOfMessage).2

            DispatchQueue.main.async { [weak self] in
                guard let self else {return}

                self.viewController?.displayUpdate(viewModel: MailStartScreenFlow.Update.ViewModel(
                    navBarBackground: backViewColor,
                    backViewColor: backViewColor,
                    navBar: navBar,
                    separatorColor: separatorColor,
                    tabBarTitle: tabBarTitle,
                    tabBarImage: tabBarImage,
                    tabBarSelectedImage: tabBarSelectedImage,
                    items: tableItems)
                )
            }
        }
    }

    func presentAlert(response: MailStartScreenFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text = response.error.localizedDescription
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(viewModel: MailStartScreenFlow.AlertInfo.ViewModel(
                title: title,
                text: text,
                buttonTitle: buttonTitle))
        }
    }

    func presentWaitIndicator(response: MailStartScreenFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: MailStartScreenFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }


    // MARK: - Private methods

    private func makeOneEmailCell(oneEmailMessage: EmailMessageWithNeededProperties,
                                  backViewColor: UIColor,
                                  index: Int,
                                  completion: @escaping (EmailCellViewModel, Int) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { 
            let emailCellBackColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
            let newEmailCellBackColor = Theme.shared.isLight ? UIHelper.Color.almostWhiteL2 : UIHelper.Color.almostBlackD2

            let backCellViewColor = oneEmailMessage.isNewEmailIconDisplaying ?? false ? newEmailCellBackColor : emailCellBackColor

            let backColorOfImage = Alphabet.colorOfFirstLetter(in: oneEmailMessage.fromName ?? oneEmailMessage.senderEmail)
            let char = String((oneEmailMessage.fromName ?? oneEmailMessage.senderEmail).prefix(1))

            var avatarImage = UIImage()
            ImageManager.createIcon(for: char,
                                    backCellViewColor: backCellViewColor,
                                    backColorOfImage: backColorOfImage,
                                    width: Constants.mainImageWidthHeight,
                                    height: Constants.mainImageWidthHeight) { image in
                avatarImage = image ?? UIImage()

                var amountOfUnreadMessages = Int()
                if oneEmailMessage.isNewEmailIconDisplaying ?? false {
                    amountOfUnreadMessages += 1
                }

                var allIconViewsForOneCell = [UIImageView]()
                var lock = os_unfair_lock_s()
                
                self.fillIconsFor(oneEmail: oneEmailMessage) { iconsInOneCell in
                    os_unfair_lock_lock(&lock)
                    allIconViewsForOneCell = iconsInOneCell
                    os_unfair_lock_unlock(&lock)
                }


                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d MMM"
                    dateFormatter.locale = Locale(identifier: "ru_RU")
                    let stringDate = dateFormatter.string(from: oneEmailMessage.receivedDate)


                    // MARK: - Collection Items

                    let attributesForAttachmentName = Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14

                    var collectionOfAttachments: [AnyDifferentiable] = []
                    var widthsOfAttachmentsFileNames = [CGFloat]()

                    if let arrayOfAttachmentNamesAndExt = oneEmailMessage.arrayOfAttachmentNamesAndExt {
                        for oneAttachmentName in arrayOfAttachmentNamesAndExt {
                            let (oneAttachmentCell, width) = makeAttachmentVM(
                                fileName: oneAttachmentName,
                                cloudBackColor: emailCellBackColor,
                                attributesForString: attributesForAttachmentName)

                            collectionOfAttachments.append(oneAttachmentCell)
                            widthsOfAttachmentsFileNames.append(width)
                        }
                    }
                    var isNewEmailIconDisplaying: Bool?
                    isNewEmailIconDisplaying = oneEmailMessage.isNewEmailIconDisplaying

                    let emailSender = NSAttributedString(string: oneEmailMessage.senderEmail, attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoSemibold17 : UIHelper.Attributed.whiteStrongRobotoSemibold17)

                    let emailTitle = NSAttributedString(string: oneEmailMessage.subject, attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoMedium14 : UIHelper.Attributed.whiteDarkDRobotoMedium14)

                    let emailText = NSAttributedString(string: oneEmailMessage.body, attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14)

                    let emailDate = NSAttributedString(string: stringDate, attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular14: UIHelper.Attributed.grayRegularDRobotoRegular14)

                    let newEmailCloudBackColor = UIHelper.Color.blue

                    let newEmailCloudTitle = NSAttributedString(string: getString(.mailStartScreenCloudNewEmailTitle), attributes: Theme.shared.isLight ? UIHelper.Attributed.whiteRobotoBold11: UIHelper.Attributed.whiteStrongRobotoBold11)

                    let oneEmailCell = EmailCellViewModel(
                        id: oneEmailMessage.id,
                        backColor: backCellViewColor,
                        avatarImage: avatarImage,
                        emailSender: emailSender,
                        emailTitle: emailTitle,
                        allIconViewsForOneCell: allIconViewsForOneCell,
                        emailText: emailText,
                        emailDate: emailDate,
                        isNewEmailIconDisplaying: isNewEmailIconDisplaying ?? false,
                        newEmailCloudBackColor: newEmailCloudBackColor,
                        newEmailCloudTitle: newEmailCloudTitle,
                        isPersonalToUserIconDisplaying: oneEmailMessage.isPersonalToUserIconDisplaying ?? false,
                        isEmportantEmailIndicatorDisplaying: oneEmailMessage.isEmportantEmailIndicatorDisplaying ?? false,
                        isExternalEmailIconDisplaying: oneEmailMessage.isExternalEmailIconDisplaying ?? false,
                        isAttachmentIconDisplaying: oneEmailMessage.isAttachmentIconDisplaying ?? false,
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
    }

    private func fillIconsFor(oneEmail: EmailMessageWithNeededProperties,
                              completion: @escaping ([UIImageView]) -> Void) {

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
