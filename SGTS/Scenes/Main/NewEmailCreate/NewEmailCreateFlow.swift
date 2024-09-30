//
//  NewEmailCreateFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import Foundation
import UIKit

enum NewEmailCreateFlow {

    enum Update {

        struct Request {
            let toEmailAddress: String?
            let copyEmailAddresses: String?
            let subjectOfMessage: String?
            let isEmptyViewVisible: Bool
        }

        struct Response {
            let isImagePreviewable: Bool
            let hasAttachment: Bool
            let isEmptyViewVisible: Bool
            let arrayOfAttachmentNamesWithExt: [String]?
            let arrayOfDictionaryNameAndDataPreviewable: [[String : Data]]?

            let fromEmailAddressText: String
            let toEmailAddress: String?
            let copyEmailAdresses: String?
            let subjectOfMessage: String?

            let textInEmailTextViewCell: String?
            let emailType: NewEmailCreateModels.NewReOrFwdEmailType
            let signature: String
        }

        typealias ViewModel = NewEmailCreateModels.ViewModel
    }

    enum OnAttachBarButtonIcon {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum RoutePayload {

        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }


    enum OnTextViewDidChange {

        struct Request {
            let textInEmailTextViewCell: String?
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnChevronTapped {

        struct Request {
            let isEmptyViewVisible: Bool
        }

        struct Response {
            let isEmptyViewVisible: Bool
        }

        struct ViewModel {}
    }

    enum OnAddressIcon {
        struct Request {
            let isUserNowTakingAddressesForCopyField: Bool
        }

        struct Response { }

        struct ViewModel { }
    }

    enum OnDidLoadViews {

        struct Request {
            let isEmptyViewVisible: Bool
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnDropdownMenu {

        struct Request {
            let menuID: NewEmailCreateModels.DropdownMenuID
            let dropDownMenuTitleCases: [NewEmailCreateModels.DropdownMenuTitle]
        }

        struct Response {
            let menuID: NewEmailCreateModels.DropdownMenuID
            let dropDownMenuTitleCases: [NewEmailCreateModels.DropdownMenuTitle]
        }

        struct ViewModel {
            let menuID: NewEmailCreateModels.DropdownMenuID
            let dropdownMenuTitlesViewModel: [NewEmailCreateModels.oneTitleOfDropdownMenu]
        }
    }

    enum OnDropdownMenuTitle {

        struct Request {
            let enumCase: NewEmailCreateModels.DropdownMenuTitle
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnAttachedFileOrImageTapped {

        struct Request {
            var fotoViewModel: FotoCellViewModel?
            var cloudEmailViewModel: CloudEmailAttachmentViewModel?
        }

        struct Response {
            var cloudEmailViewModel: CloudEmailAttachmentViewModel?
        }

        struct ViewModel {}
    }

    enum OnXButtonAttachedCloud {

        struct Request {
            let id: String
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnDownloadIconOrToSaveAttachedFile {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnQuattroIcon {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnSendButton {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnReplyToAllButton {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnForwardButton {

        struct Request {}

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
            let error: Error?
            let alertAt: NewEmailCreateModels.AlertAtOrCase?
        }

        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}
