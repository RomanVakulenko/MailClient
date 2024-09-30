//
//  AttachmentsScreenPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import UIKit
import DifferenceKit
import SnapKit

protocol AttachmentsScreenPresentationLogic {
    func presentSearchBar(response: AttachmentsScreenFlow.OnSearchBarIconTap.Response)
    func presentUpdate(response: AttachmentsScreenFlow.Update.Response)
    func presentWaitIndicator(response: AttachmentsScreenFlow.OnWaitIndicator.Response)
    func presentAlert(response: AttachmentsScreenFlow.AlertInfo.Response)
    func presentRouteToSideMenu(response: AttachmentsScreenFlow.RoutePayload.Response)

    func presentRouteToOpenAttachmentInOtherApp(response: AttachmentsScreenFlow.OnSelectItem.Response)
}


final class AttachmentsScreenPresenter: AttachmentsScreenPresentationLogic {

    // MARK: - Public properties

    weak var viewController: AttachmentsScreenDisplayLogic?

    // MARK: - Public methods

    func presentRouteToOpenAttachmentInOtherApp(response: AttachmentsScreenFlow.OnSelectItem.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToOpenFileInOtherApp(viewModel: AttachmentsScreenFlow.OnSelectItem.ViewModel())
        }
    }

    func presentRouteToSideMenu(response: AttachmentsScreenFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSideMenu(viewModel: AttachmentsScreenFlow.RoutePayload.ViewModel())
        }
    }

    func presentSearchBar(response: AttachmentsScreenFlow.OnSearchBarIconTap.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let searchBarAttributedPlaceholder = NSAttributedString(string: getString(.searchViewPlaceholder), attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.grayRegularD2RobotoRegular16)

        let searchText = response.searchText ?? ""
        let searchTextColor = Theme.shared.isLight ? UIHelper.Color.blackMiddleL : UIHelper.Color.whiteStrong
        let searchIcon = Theme.shared.isLight ? UIHelper.Image.searchIcon24x24L : UIHelper.Image.searchIcon24x24D

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.toggleSearchBar(viewModel: AttachmentsScreenFlow.OnSearchBarIconTap.ViewModel(
                id: 12,
                backColor: backColor,
                isSearchBarDisplaying: response.isSearchBarDisplaying,
                searchBarAttributedPlaceholder: searchBarAttributedPlaceholder,
                searchText: searchText, 
                searchIcon: searchIcon,
                searchTextColor: searchTextColor,
                separatorColor: separatorColor,
                insets: .zero)
            )
        }
    }


    func presentUpdate(response: AttachmentsScreenFlow.Update.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        var tableItems: [AnyDifferentiable] = []

        for oneAttachment in response.attachments {
            let fileExtension = oneAttachment.fileNameWithExt.components(separatedBy: ".").last
            let iconOfAttachmentExtension = ImageManager.getFileIcon(for: fileExtension ?? "")

            let attributedFileNameWithExt = NSAttributedString(
                string: oneAttachment.fileNameWithExt,
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoMedium17 : UIHelper.Attributed.whiteStrongDRobotoMedium17)

            let attributedNameAndSurname = NSAttributedString(
                string: oneAttachment.nameAndSurname,
                attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)

// если будет Date
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MMMM yyyy"
//            let stringDate = dateFormatter.string(from: oneAttachment.downloadingDate)
            
            let attributedDate = NSAttributedString(
                string: oneAttachment.downloadingDate,
                attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14)

            let oneAttachmentSize = formattedFileSize(size: Int(oneAttachment.downloadingSize) ?? 0)

            let attributedSize = NSAttributedString(
                string: oneAttachmentSize,
                attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)

            let oneAttachmentCell = AttachmentCellViewModel(
                id: oneAttachment.attachmentLUID ?? "was no luid",
                backColor: backColor,
                iconOfAttachmentExtension: iconOfAttachmentExtension,
                fileNameWithExt: attributedFileNameWithExt,
                nameAndSurname: attributedNameAndSurname,
                downloadingDate: attributedDate,
                downloadingSize: attributedSize,
                separatorInsets: .zero,
                insets: UIEdgeInsets(top: UIHelper.Margins.medium16px,
                                     left: UIHelper.Margins.medium16px,
                                     bottom: UIHelper.Margins.medium16px,
                                     right: UIHelper.Margins.medium16px))

            tableItems.append(AnyDifferentiable(oneAttachmentCell))
        }


        let title = NSAttributedString(
            string: getString(.attachmentsTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD
        let sandwichNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.emailSandwichL : UIHelper.Image.emailSandwichD)

        let searchNavBarIcon = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.searchIcon20L : UIHelper.Image.searchIcon20D)

        let navBar = CustomNavBar(title: title,
                                  isLeftBarButtonEnable: true,
                                  isLeftBarButtonCustom: true,
                                  leftBarButtonCustom: sandwichNavBarIcon,
                                  rightBarButtons: [searchNavBarIcon])

        let tabBarTitle = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .attachments).0
        let tabBarImage = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .attachments).1
        let tabBarSelectedImage = TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .attachments).2

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: AttachmentsScreenFlow.Update.ViewModel(
                navBarBackground: backColor,
                backViewColor: backColor,
                navBar: navBar,
                separatorColor: separatorColor,
                tabBarTitle: tabBarTitle,
                tabBarImage: tabBarImage,
                tabBarSelectedImage: tabBarSelectedImage,
                items: tableItems)
            )
        }
    }


        func presentAlert(response: AttachmentsScreenFlow.AlertInfo.Response) {
            let title = getString(.error)
            let text = response.error.localizedDescription
            let buttonTitle = getString(.closeAction)
    
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.displayAlert(viewModel: AttachmentsScreenFlow.AlertInfo.ViewModel(title: title,
                                                                                                               text: text,
                                                                                                               buttonTitle: buttonTitle))
            }
        }
    
        func presentWaitIndicator(response: AttachmentsScreenFlow.OnWaitIndicator.Response) {
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.displayWaitIndicator(viewModel: AttachmentsScreenFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
            }
        }


    // MARK: - Private methods

    private func formattedFileSize(size: Int) -> String {
        let kb = 1024
        let mb = kb * 1024
        let gb = mb * 1024

        if size >= gb {
            return String(format: "%.1f Gb", Double(size) / Double(gb))
        } else if size >= mb {
            return String(format: "%.1f Mb", Double(size) / Double(mb))
        } else if size >= kb {
            return String(format: "%.1f Kb", Double(size) / Double(kb))
        } else {
            return "\(size) B"
        }
    }
}
