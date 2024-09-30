//
//  MailStartScreenFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import Foundation

enum MailStartScreenFlow {
    
    enum Update {
        
        struct Request {}
        
        struct Response {
            let mailsFromDatabase: [EmailMessageWithNeededProperties]
            let someMessagesFromTotal: Int
            let totalMessages: Int
            let typeOfMessage: TabBarManager.MessageType
        }
        
        typealias ViewModel = MailStartScreenModel.ViewModel
    }

    enum OnDidLoadViews {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnBarButtonTap {

        struct Request {}

        struct Response {
            let emailType: NewEmailCreateModels.NewReOrFwdEmailType
        }

        struct ViewModel {}
    }

    enum OnLongPressGestureTap {

        struct Request {
            let id: String
        }

        struct Response {}

        struct ViewModel {}
    }

    enum OnSelectItem {
        
        struct Request {
            let id: String
        }
        
        struct Response {}
        
        struct ViewModel {}
    }

    enum OnPullToRefresh {
        
        struct Request {}

        struct Response {}

        struct ViewModel {}
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
