//
//  EmailPickingScreenFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import Foundation

enum EmailPickingScreenFlow {

    enum Update {
        
        struct Request {}
        
        struct Response {
            let mailsForDisplay: [EmailMessageWithNeededProperties]
            let pickedEmailIds: Set<String>
            let isAllEmailsBoxDidTap: Bool
            let isOnlyOneEmailPicked: Bool
            let typeOfMessage: TabBarManager.MessageType
        }
        
        typealias ViewModel = EmailPickingScreenModel.ViewModel
    }

    enum OnDidLoadViews {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnArchiveNavBarIcon {
        
        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum MovingTo {

        struct Request {
            let folder: String
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnEnvelopNavBarButton {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnDropdownMenu {

        struct Request {}

        struct Response {
            let dropDownMenuTitleCases: [EmailPickingScreenModel.DropdownMenuTitle]
            let isOnlyOneEmailPicked: Bool
        }

        struct ViewModel {
            let dropdownMenuTitlesViewModel: [EmailPickingScreenModel.oneTitleOfDropdownMenu]
        }
    }

    enum OnDropdownMenuTitle {

        struct Request {
            let enumCase: EmailPickingScreenModel.DropdownMenuTitle
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnMoveToTitleOfDropdownMenu {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnSelectItem {
        
        struct Request {
            let pickedEmailId: String?
        }
        
        struct Response {
            let pickedEmailId: Set<String>
        }
        
        struct ViewModel {
            let pickedEmailId: Set<String>
        }
    }

    enum RoutePayload {

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
            let alertAt: EmailPickingScreenModel.AlertAtOrCase?
        }

        struct ViewModel {
            let title: String?
            let text: String?
            let firstButtonTitle: String?
            let secondButtonTitle:  String?
        }
    }
}
