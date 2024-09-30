//
//  UserProfileChangeNameFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import Foundation

enum UserProfileChangeNameFlow {
    
    enum Update {
        
        struct Request {}
        
        struct Response {
            let userFullName: String
            let senderName: String?
        }

        typealias ViewModel = UserProfileChangeNameViewModel
    }

    enum OnDidLoadViews {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnTextFieldDidChange {

        struct Request {
            let enteredSenderName: String?
        }

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
        
        struct Response {}
        
        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}
