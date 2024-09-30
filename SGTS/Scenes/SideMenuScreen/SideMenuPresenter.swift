//
//  SideMenuPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import UIKit
import DifferenceKit

protocol SideMenuPresentationLogic {
    func presentUpdate(response: SideMenuFlow.Update.Response)
    func presentRouteBack(request: SideMenuFlow.RoutePayload.Response)
    func presentRouteToSelectedScreen(response: SideMenuFlow.OnSelectItem.Response)

    func presentAlert(response: SideMenuFlow.AlertInfo.Response)
}


final class SideMenuPresenter: SideMenuPresentationLogic {

    enum Constants {
        static let mainImageWidthHeight: CGFloat = 45
        static let cellHeight: CGFloat = 16 + 77 + 16
    }

    // MARK: - Public properties

    weak var viewController: SideMenuDisplayLogic?
    private var items: [AnyDifferentiable] = []

    // MARK: - Public methods

    func presentRouteBack(request: SideMenuFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBack(viewModel: SideMenuFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToSelectedScreen(response: SideMenuFlow.OnSelectItem.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSelectedScreen(viewModel: SideMenuFlow.RoutePayload.ViewModel())
        }
    }


    func presentUpdate(response: SideMenuFlow.Update.Response) {
        let concurrentQueue = DispatchQueue(label: "kz.mailDetails.fileQueue",
                                            attributes: .concurrent)
        concurrentQueue.async { [weak self] in
            guard let self = self else { return }

            let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
            let grayViewColor = Theme.shared.isLight ? UIHelper.Color.grayAlpha06 : UIHelper.Color.blackAlpha06D
            let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

            let incomingIcon = Theme.shared.isLight ? UIHelper.Image.incomingIcon24L : UIHelper.Image.incomingIcon24D
            let sentIcon = Theme.shared.isLight ? UIHelper.Image.sentIcon24L : UIHelper.Image.sentIcon24D
            let outgoingIcon = Theme.shared.isLight ? UIHelper.Image.outgoingIcon24L : UIHelper.Image.outgoingIcon24D
            let draftsIcon = Theme.shared.isLight ? UIHelper.Image.reportOrDraftIcon24L : UIHelper.Image.reportOrDraftIcon24D
            let archiveIcon = Theme.shared.isLight ? UIHelper.Image.archiveIcon24x24L : UIHelper.Image.archiveIcon24x24D
            let trashIcon = Theme.shared.isLight ? UIHelper.Image.trashIcon24x24L : UIHelper.Image.trashIcon24x24D
            let sideMenuAttachmentIcon = Theme.shared.isLight ? UIHelper.Image.sideMenuAttachmentIcon24L : UIHelper.Image.sideMenuAttachmentIcon24D
            let settingsIcon = Theme.shared.isLight ? UIHelper.Image.gearIcon24L : UIHelper.Image.gearIcon24D
            let searchIcon = Theme.shared.isLight ? UIHelper.Image.searchIcon24x24L : UIHelper.Image.searchIcon24x24D
            let chevronImage = Theme.shared.isLight ? UIHelper.Image.chevronRightL : UIHelper.Image.chevronRightD

            let attributesForText = Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular16 : UIHelper.Attributed.whiteDarkDRobotoRegular16
            let attributesForCounter = Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.whiteDarkDRobotoRegular16


            let counterTextForIncoming = response.incomingMessagesAmountOfTotal + "/" + response.incomingMessagesTotal
            let counterTextForSent = response.sentMessagesTotal
            let counterTextForOutgoing = response.outgoingMessagesTotal
            let counterTextForDrafts = response.draftsMessagesTotal
            let counterTextForArchive = response.archivedMessagesTotal
            let counterTextForTrash = response.deletedMessagesTotal


            switch response.typeOfUpdate {
            case .withZeros:
                DispatchQueue.global(qos: .userInitiated).async {
                    self.updateAccordingTo(typeOfUpdate: .withZeros, items: &self.items, backColor: backColor, grayViewColor: grayViewColor, separatorColor: separatorColor, userFullName: response.userFullName, userEmail: response.userEmail, incomingIcon: incomingIcon, sentIcon: sentIcon, outgoingIcon: outgoingIcon, draftsIcon: draftsIcon, archiveIcon: archiveIcon, trashIcon: trashIcon, sideMenuAttachmentIcon: sideMenuAttachmentIcon, settingsIcon: settingsIcon, searchIcon: searchIcon, chevronImage: chevronImage, attributesForText: attributesForText, attributesForCounter: attributesForCounter, counterTextForIncoming: counterTextForIncoming, counterTextForSent: counterTextForSent, counterTextForOutgoing: counterTextForOutgoing, counterTextForDrafts: counterTextForDrafts, counterTextForArchive: counterTextForArchive, counterTextForTrash: counterTextForTrash) { grayViewColor, items in

                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            viewController?.displayUpdate(viewModel: SideMenuFlow.Update.ViewModel(
                                grayViewColor: grayViewColor,
                                items: items))
                        }
                    }
                }
            case .incomingCount:
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    items[2] = makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.incoming,
                                                        backColor: backColor,
                                                        icon: incomingIcon,
                                                        text: getString(.mailStartScreenTitle),
                                                        attributesForText: attributesForText,
                                                        attributesForCounter: attributesForCounter,
                                                        counterText: counterTextForIncoming)

                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        viewController?.displayUpdate(viewModel: SideMenuFlow.Update.ViewModel(
                            grayViewColor: grayViewColor,
                            items: items))
                    }
                }
            case .otherCount:
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    updateAccordingTo(typeOfUpdate: .otherCount, items: &items, backColor: backColor, grayViewColor: grayViewColor, separatorColor: separatorColor, userFullName: response.userFullName, userEmail: response.userEmail, incomingIcon: incomingIcon, sentIcon: sentIcon, outgoingIcon: outgoingIcon, draftsIcon: draftsIcon, archiveIcon: archiveIcon, trashIcon: trashIcon, sideMenuAttachmentIcon: sideMenuAttachmentIcon, settingsIcon: settingsIcon, searchIcon: searchIcon, chevronImage: chevronImage, attributesForText: attributesForText, attributesForCounter: attributesForCounter, counterTextForIncoming: counterTextForIncoming, counterTextForSent: counterTextForSent, counterTextForOutgoing: counterTextForOutgoing, counterTextForDrafts: counterTextForDrafts, counterTextForArchive: counterTextForArchive, counterTextForTrash: counterTextForTrash) { grayViewColor, items in

                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.viewController?.displayUpdate(viewModel: SideMenuFlow.Update.ViewModel(
                                grayViewColor: grayViewColor,
                                items: items))
                        }
                    }
                }
            case .allScreenWithAllCounts:
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    updateAccordingTo(typeOfUpdate: .allScreenWithAllCounts, items: &items, backColor: backColor, grayViewColor: grayViewColor, separatorColor: separatorColor, userFullName: response.userFullName, userEmail: response.userEmail, incomingIcon: incomingIcon, sentIcon: sentIcon, outgoingIcon: outgoingIcon, draftsIcon: draftsIcon, archiveIcon: archiveIcon, trashIcon: trashIcon, sideMenuAttachmentIcon: sideMenuAttachmentIcon, settingsIcon: settingsIcon, searchIcon: searchIcon, chevronImage: chevronImage, attributesForText: attributesForText, attributesForCounter: attributesForCounter, counterTextForIncoming: counterTextForIncoming, counterTextForSent: counterTextForSent, counterTextForOutgoing: counterTextForOutgoing, counterTextForDrafts: counterTextForDrafts, counterTextForArchive: counterTextForArchive, counterTextForTrash: counterTextForTrash) { grayViewColor, items in

                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.viewController?.displayUpdate(viewModel: SideMenuFlow.Update.ViewModel(
                                grayViewColor: grayViewColor,
                                items: items))
                        }
                    }
                }
            }
        }
    }


    func presentAlert(response: SideMenuFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text = response.error.localizedDescription
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(viewModel: SideMenuFlow.AlertInfo.ViewModel(
                title: title,
                text: text,
                buttonTitle: buttonTitle))
        }
    }
    //    func presentWaitIndicator(response: SideMenuFlow.OnWaitIndicator.Response) {
    //        DispatchQueue.main.async { [weak self] in
    //            self?.viewController?.displayWaitIndicator(viewModel: SideMenuFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
    //        }
    //    }


    // MARK: - Private methods

    private func updateAccordingTo(typeOfUpdate: SideMenuModel.TypeOfUpdate,
                                   items: inout [AnyDifferentiable],
                                   backColor: UIColor,
                                   grayViewColor: UIColor,
                                   separatorColor: UIColor,
                                   userFullName: String,
                                   userEmail: String,
                                   incomingIcon: UIImage,
                                   sentIcon: UIImage,
                                   outgoingIcon: UIImage,
                                   draftsIcon: UIImage,
                                   archiveIcon: UIImage,
                                   trashIcon: UIImage,
                                   sideMenuAttachmentIcon: UIImage,
                                   settingsIcon: UIImage,
                                   searchIcon: UIImage,
                                   chevronImage: UIImage,
                                   attributesForText: [NSAttributedString.Key : Any],
                                   attributesForCounter: [NSAttributedString.Key : Any],
                                   counterTextForIncoming: String,
                                   counterTextForSent: String,
                                   counterTextForOutgoing: String,
                                   counterTextForDrafts: String,
                                   counterTextForArchive: String,
                                   counterTextForTrash : String,
                                   completion: @escaping (UIColor, [AnyDifferentiable]) -> Void) {
        let concurrentQueue = DispatchQueue(label: "kz.gtech.mailDetails.fileQueue",
                                            attributes: .concurrent)
        if typeOfUpdate == .allScreenWithAllCounts {
            items = []
        }

        if typeOfUpdate == .withZeros || typeOfUpdate == .allScreenWithAllCounts {

                //0
                items.append(makeUserNameAndEmailVM(id: SideMenuModel.MenuItems.userNameAndEmail,
                                                              backColor: backColor,
                                                              fullName: userFullName,
                                                              email: userEmail,
                                                              chevronImage: chevronImage))

                //1
                items.append(makeSeparatorVMWith(id: 0,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.medium8px,
                                                 separatorColor: separatorColor))
                //2
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.incoming,
                                                      backColor: backColor,
                                                      icon: incomingIcon,
                                                      text: getString(.mailStartScreenTitle),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter,
                                                      counterText: counterTextForIncoming))
                //3
                items.append(makeSeparatorVMWith(id: 1,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.small1px,
                                                 separatorColor: separatorColor))
                //4
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.sent,
                                                      backColor: backColor,
                                                      icon: sentIcon,
                                                      text: getString(.alreadySentMessage),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter,
                                                      counterText: counterTextForSent))
                //5
                items.append(makeSeparatorVMWith(id: 2,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.small1px,
                                                 separatorColor: separatorColor))
                //6
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.outgoing,
                                                      backColor: backColor,
                                                      icon: outgoingIcon,
                                                      text: getString(.outgoingMessages),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter,
                                                      counterText: counterTextForOutgoing))
                //7
                items.append(makeSeparatorVMWith(id: 3,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.medium8px,
                                                 separatorColor: separatorColor))
                //8
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.drafts,
                                                      backColor: backColor,
                                                      icon: trashIcon,
                                                      text: getString(.draftMessages),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter,
                                                      counterText: counterTextForDrafts))
                //9
                items.append(makeSeparatorVMWith(id: 4,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.small1px,
                                                 separatorColor: separatorColor))
                //10
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.archived,
                                                      backColor: backColor,
                                                      icon: archiveIcon,
                                                      text: getString(.archivedMessages),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter,
                                                      counterText: counterTextForArchive))
                //11
                items.append(makeSeparatorVMWith(id: 5,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.small1px,
                                                 separatorColor: separatorColor))
                //12
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.deleted,
                                                      backColor: backColor,
                                                      icon: trashIcon,
                                                      text: getString(.deletedMessages),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter,
                                                      counterText: counterTextForTrash))
                //13
                items.append(makeSeparatorVMWith(id: 6,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.medium8px,
                                                 separatorColor: separatorColor))
                //14
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.attachments,
                                                      backColor: backColor,
                                                      icon: sideMenuAttachmentIcon,
                                                      text: getString(.attachmentsTitle),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter))
                //15
                items.append(makeSeparatorVMWith(id: 7,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.small1px,
                                                 separatorColor: separatorColor))
                //16
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.settings,
                                                      backColor: backColor,
                                                      icon: settingsIcon,
                                                      text: getString(.settingsTitle),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter))
                //17
                items.append(makeSeparatorVMWith(id: 8,
                                                 backColor: backColor,
                                                 borderWidth: UIHelper.Margins.small1px,
                                                 separatorColor: separatorColor))
                //18
                items.append(makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.searchContactsAtServer,
                                                      backColor: backColor,
                                                      icon: searchIcon,
                                                      text: getString(.searchContactsAtWeb),
                                                      attributesForText: attributesForText,
                                                      attributesForCounter: attributesForCounter))

                completion(grayViewColor, items)
        }

        if typeOfUpdate == .otherCount {
            //4
            items[4] = makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.sent,
                                                backColor: backColor,
                                                icon: sentIcon,
                                                text: getString(.alreadySentMessage),
                                                attributesForText: attributesForText,
                                                attributesForCounter: attributesForCounter,
                                                counterText: counterTextForSent)
            //6
            items[6] = makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.outgoing,
                                                backColor: backColor,
                                                icon: outgoingIcon,
                                                text: getString(.outgoingMessages),
                                                attributesForText: attributesForText,
                                                attributesForCounter: attributesForCounter,
                                                counterText: counterTextForOutgoing)
            //8
            items[8] = makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.drafts,
                                                backColor: backColor,
                                                icon: trashIcon,
                                                text: getString(.draftMessages),
                                                attributesForText: attributesForText,
                                                attributesForCounter: attributesForCounter,
                                                counterText: counterTextForDrafts)
            //10
            items[10] = makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.archived,
                                                 backColor: backColor,
                                                 icon: archiveIcon,
                                                 text: getString(.archivedMessages),
                                                 attributesForText: attributesForText,
                                                 attributesForCounter: attributesForCounter,
                                                 counterText: counterTextForArchive)
            //12
            items[12] = makeIconTextAndCounterVM(id: SideMenuModel.MenuItems.deleted,
                                                 backColor: backColor,
                                                 icon: trashIcon,
                                                 text: getString(.deletedMessages),
                                                 attributesForText: attributesForText,
                                                 attributesForCounter: attributesForCounter,
                                                 counterText: counterTextForTrash)
            completion(grayViewColor, items)
        }
    }


    private func makeUserNameAndEmailVM(id: AnyHashable,
                                        backColor: UIColor,
                                        fullName: String,
                                        email: String,
                                        chevronImage: UIImage) -> AnyDifferentiable {

        let backColorOfImage = Alphabet.colorOfFirstLetter(in: fullName)
        let char = String(fullName.prefix(1))

        var avatarImage = UIImage()
        let semaphore = DispatchSemaphore(value: 0)
        ImageManager.createIcon(for: char,
                                backCellViewColor: backColor,
                                backColorOfImage: backColorOfImage,
                                width: Constants.mainImageWidthHeight,
                                height: Constants.mainImageWidthHeight) { image in
            avatarImage = image ?? UIImage()
            semaphore.signal()
        }
        semaphore.wait()

        let name = NSAttributedString(
            string: fullName,
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoRegular18 : UIHelper.Attributed.whiteStrongDRobotoRegular18)
        let email = NSAttributedString(
            string: email,
            attributes: UIHelper.Attributed.blueUnderlinedRobotoRegular12)

        let userProfileCellVM = UserProfileCellViewModel(
            id: id,
            cellBackColor: backColor,
            avatarImage: avatarImage,
            name: name,
            email: email,
            chevron: chevronImage,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium16px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium16px,
                                 right: UIHelper.Margins.medium16px))
        return AnyDifferentiable(userProfileCellVM)
    }

    private func makeSeparatorVMWith(id: AnyHashable,
                                     backColor: UIColor,
                                     borderWidth: CGFloat,
                                     separatorColor: UIColor)  -> AnyDifferentiable {
        let separatorCellVM = SeparatorCellViewModel(
            id: id,
            separatorColor: separatorColor,
            separatorBorderWidth: borderWidth,
            insets: .zero)
        return AnyDifferentiable(separatorCellVM)
    }

    private func makeIconTextAndCounterVM(id: AnyHashable,
                                          backColor: UIColor,
                                          icon: UIImage,
                                          text: String,
                                          attributesForText: [NSAttributedString.Key : Any],
                                          attributesForCounter: [NSAttributedString.Key : Any],
                                          counterText: String? = nil) -> AnyDifferentiable {

        let title = NSAttributedString(string: text, attributes: attributesForText)
        let counter = NSAttributedString(string: counterText ?? "", attributes: attributesForCounter)

        let iconTextAndCounterVM = IconTextAndCounterCellViewModel(
            id: id,
            cellBackColor: backColor,
            icon: icon,
            title: title,
            counterText: counter,
            insets: .zero)

        return AnyDifferentiable(iconTextAndCounterVM)
    }

}
