//
//  UserProfileSendReportFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.07.2024.
//

import Foundation
import UIKit

enum UserProfileSendReportFlow {

    enum Update {

        struct Request {
            let subject: String?
        }

        struct Response {
            let isImageInsideAttachment: Bool
            let hasAttachment: Bool
            let arrayOfAttachmentNamesWithExt: [String]?
            let arrayOfDictionaryNameAndDataPreviewable: [[String : Data]]?

            let userEmailAddress: String? //нужен ли ? 
            let toEmailAddress: String
            let subjectOfMessage: String

            let textInEmailTextViewCell: String?
            let signature: String
        }

        typealias ViewModel = UserProfileSendReportModels.ViewModel
    }

    enum RoutePayload {

        struct Request {}
        
        struct Response {}
        
        struct ViewModel {
            var fotoViewModel: FotoCellViewModel?
            var сloudEmailViewModel: CloudEmailAttachmentViewModel?
        }
    }

    enum OnTextViewDidChange {

        struct Request {
            let textInEmailTextViewCell: String?
        }

        struct Response {}

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
//            let isEmptyViewVisible: Bool
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnAttachBarButtonIcon {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnDropdownMenu {

        struct Request {
            let dropDownMenuTitleCases: [UserProfileSendReportModels.DropdownMenuTitle]
        }

        struct Response {
            let dropDownMenuTitleCases: [UserProfileSendReportModels.DropdownMenuTitle]
        }

        struct ViewModel {
            let dropdownMenuTitlesViewModel: [UserProfileSendReportModels.oneTitleOfDropdownMenu]
        }
    }

    enum OnDropdownMenuTitle {

        struct Request {
            let enumCase: UserProfileSendReportModels.DropdownMenuTitle
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
