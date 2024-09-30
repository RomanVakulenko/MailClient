//
//  ImageFullScreenFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import Foundation
import UIKit

enum ImageFullScreenFlow {

    enum Update {

        struct Request { }

        struct Response {
            let image: UIImage
            let fileName: String
            let fileSize: Int?
        }

        typealias ViewModel = ImageFullScreenModel.ViewModel
    }

    enum RoutePayload {

        struct Request {}

        struct Response {}

        struct ViewModel { }
    }

    enum OnDidLoadViews {

        struct Request { }

        struct Response {
            let image: UIImage
        }

        struct ViewModel {}
    }


    enum OnDropdownMenu {

        struct Request {
            let dropDownMenuTitleCases: [ImageFullScreenModel.DropdownMenuTitle]
        }

        struct Response {
            let dropDownMenuTitleCases: [ImageFullScreenModel.DropdownMenuTitle]
        }

        struct ViewModel {
            let dropdownMenuTitlesViewModel: [ImageFullScreenModel.oneTitleOfDropdownMenu]
        }
    }

    enum OnDropdownMenuTitle {

        struct Request {
            let enumCase: ImageFullScreenModel.DropdownMenuTitle
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnWaitIndicator {

        struct Request {}

        struct Response {
            let isShow: Bool
        }

        struct ViewModel {
            let isShow: Bool
        }
    }

    enum AlertInfo {

        struct Request {}

        struct Response {
            let error: Error
        }

        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}


