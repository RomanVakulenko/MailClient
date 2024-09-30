//
//  MovePickedEmailsFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import Foundation

enum MovePickedEmailsFlow {
    
    enum Update {
        
        struct Request {}
        
        struct Response {}
        
        typealias ViewModel = MovePickedEmailsModel.ViewModel
    }

    enum OnDidLoadViews {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnSelectItem {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
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
        
        struct Response {}
        
        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}
