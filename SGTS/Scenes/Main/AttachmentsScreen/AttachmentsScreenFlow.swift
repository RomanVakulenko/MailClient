//
//  AttachmentsScreenFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import Foundation

enum AttachmentsScreenFlow {
    
    enum Update {
        
        struct Request {}
        
        struct Response {
//            let isNewEmail: Bool
//            let isPersonalToUserIconDisplaying: Bool
//            let isEmportantEmailIndicatorDisplaying: Bool
//            let isExternalEmailIconDisplaying: Bool
//            let isAttachmentIconDisplaying: Bool
            let attachments: [AttachmentCellModelFromDatabase]
        }
        
        typealias ViewModel = AttachmentsScreenModel.ViewModel
    }

    enum OnDidLoadViews {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnSearchBarIconTap {

        struct Request {
            let searchText: String?
            let isSearchBarDisplaying: Bool
        }

        struct Response {
            let searchText: String?
            let isSearchBarDisplaying: Bool
            let filteredAttachments: Array<String>?
        }

        typealias ViewModel = SearchViewModel
    }

    enum OnBurgerMenuTap {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnLongPressGestureTap {

        struct Request {
            let id: String
        }

        struct Response {
            let id: String
        }

        struct ViewModel {
            let id: String
        }
    }

    enum OnSelectItem {
        
        struct Request {
            let id: String
        }
        
        struct Response { }
        
        struct ViewModel { }
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
            let error: Error
        }

        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}
