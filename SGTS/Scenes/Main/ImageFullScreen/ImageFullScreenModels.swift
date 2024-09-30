//
//  ImageFullScreenModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import UIKit
import DifferenceKit

enum ImageFullScreenModel {

    enum Errors: Error {
        case cantOpenFile
    }

    enum DropdownMenuTitle {
        case downloadFoto, openImageInOtherApp
    }

    struct oneTitleOfDropdownMenu {
        let enumCaseOfDropdownMenu: DropdownMenuTitle
        let attributedString: NSAttributedString
    }

    struct ViewModel {
            let statusBarBackground: UIColor
            let upperNavigationViewBackground: UIColor
            let backViewColor: UIColor?
            let imageFullScreen: UIImage
            let insets: UIEdgeInsets?
            let screenTitle: NSAttributedString
            let imageSizeSubtitle: NSAttributedString
            let backArrowIcon: UIImage
            let threeDotsMenuIcon: UIImage

            init(statusBarBackground: UIColor, upperNavigationViewBackground: UIColor, backViewColor: UIColor? = nil, imageFullScreen: UIImage, insets: UIEdgeInsets? = .zero, screenTitle: NSAttributedString, imageSizeSubtitle: NSAttributedString, backArrowIcon: UIImage, threeDotsMenuIcon: UIImage) {
                self.statusBarBackground = statusBarBackground
                self.upperNavigationViewBackground = upperNavigationViewBackground
                self.backViewColor = backViewColor
                self.imageFullScreen = imageFullScreen
                self.insets = insets
                self.screenTitle = screenTitle
                self.imageSizeSubtitle = imageSizeSubtitle
                self.backArrowIcon = backArrowIcon
                self.threeDotsMenuIcon = threeDotsMenuIcon
            }
        }
    }


    extension ImageFullScreenModel.ViewModel: Differentiable {
        var differenceIdentifier: AnyHashable {
            imageFullScreen
        }

        func isContentEqual(to source: ImageFullScreenModel.ViewModel) -> Bool {
            source.statusBarBackground == statusBarBackground &&
            source.upperNavigationViewBackground == upperNavigationViewBackground &&
            source.backViewColor == backViewColor &&
            source.imageFullScreen == imageFullScreen &&
            source.insets == insets &&
            source.screenTitle == screenTitle  &&
            source.imageSizeSubtitle == imageSizeSubtitle &&
            source.backArrowIcon == backArrowIcon &&
            source.threeDotsMenuIcon == threeDotsMenuIcon
        }
    }


