//
//  ImageFullScreenPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import UIKit
import DifferenceKit

protocol ImageFullScreenPresentationLogic {
    func presentUpdate(response: ImageFullScreenFlow.Update.Response)
    func presentWaitIndicator(response: ImageFullScreenFlow.OnWaitIndicator.Response)
    func presentAlert(response: ImageFullScreenFlow.AlertInfo.Response)
    func didTapBackArrow()
    func presentDropdownMenu(response: ImageFullScreenFlow.OnDropdownMenu.Response)
    
    func presentRouteToSaveDialog(response: ImageFullScreenFlow.OnDropdownMenuTitle.Response)
    func presentRouteToOpenImageInOtherApp(response: ImageFullScreenFlow.OnDropdownMenuTitle.Response)
}


final class ImageFullScreenPresenter: ImageFullScreenPresentationLogic {

//    enum Constants {
//        static let leftRightInset: CGFloat = 8
//    }

    // MARK: - Public properties

    weak var viewController: ImageFullScreenDisplayLogic?

    // MARK: - Public methods

    func didTapBackArrow() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBack(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel())
        }
    }

    func presentDropdownMenu(response: ImageFullScreenFlow.OnDropdownMenu.Response) {
        let titlesOfDropdownMenu = response.dropDownMenuTitleCases.map { titleCase in
            ImageFullScreenModel.oneTitleOfDropdownMenu(
                enumCaseOfDropdownMenu: titleCase,
                attributedString: NSAttributedString(
                    string: titleCase.getTitle(),
                    attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14
                )
            )
        }

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayDropdownMenuAtNavBarIcon(viewModel: ImageFullScreenFlow.OnDropdownMenu.ViewModel(dropdownMenuTitlesViewModel: titlesOfDropdownMenu))
        }
    }

    func presentRouteToSaveDialog(response: ImageFullScreenFlow.OnDropdownMenuTitle.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSaveDialog(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToOpenImageInOtherApp(response: ImageFullScreenFlow.OnDropdownMenuTitle.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToOpenImageInOtherApp(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel())
        }
    }


    func presentUpdate(response: ImageFullScreenFlow.Update.Response) {
        let screenTitle = NSMutableAttributedString(
            string: response.fileName,
            attributes: Theme.shared.isLight ? UIHelper.Attributed.whiteRobotoMedium20 : UIHelper.Attributed.blackMiddleLRobotoMedium20 )

        var imageSizeSubtitle = NSMutableAttributedString()
        if let size = response.fileSize {
            imageSizeSubtitle = NSMutableAttributedString(
                string: "\(size) Kb",
                attributes: UIHelper.Attributed.whiteHalfRobotoRegular12)
        }

        let backArrowIcon = Theme.shared.isLight ? UIHelper.Image.backArrowWhite16px : UIHelper.Image.backArrow16pxD
        let threeDotsMenuIcon = Theme.shared.isLight ? UIHelper.Image.imageFullScreenThreeDotsWhiteIcon24x24 : UIHelper.Image.emailPickingScreenThreeDotsNavBarIcon24x24D

        let statusBarBackground = UIHelper.Color.someGray //there is no color for darkMode
        let upperNavigationViewBackground = UIHelper.Color.grayAlpha06 //there is no color for darkMode
        let backViewColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(
                viewModel: ImageFullScreenFlow.Update.ViewModel(
                    statusBarBackground: statusBarBackground,
                    upperNavigationViewBackground: upperNavigationViewBackground,
                    backViewColor: backViewColor,
                    imageFullScreen: response.image,
                    screenTitle: screenTitle,
                    imageSizeSubtitle: imageSizeSubtitle,
                    backArrowIcon: backArrowIcon,
                    threeDotsMenuIcon: threeDotsMenuIcon)
            )
        }

    }

    func presentAlert(response: ImageFullScreenFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text = response.error.localizedDescription
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(
                viewModel: ImageFullScreenFlow.AlertInfo.ViewModel(title: title,
                                                                     text: text,
                                                                     buttonTitle: buttonTitle))
        }
    }

    func presentWaitIndicator(response: ImageFullScreenFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: ImageFullScreenFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }

}

// MARK: - NewEmailCreateModel.DropdownMenuTitle

extension ImageFullScreenModel.DropdownMenuTitle {
    func getTitle() -> String {
        switch self {
        case .downloadFoto:
            return getString(.imageFullScreenDownloadImage)
        case .openImageInOtherApp:
            return getString(.imageFullScreenOpenInOtherApp)
        }
    }
}
