//
//  EnterPasswordAfterQRFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation

enum EnterPasswordAfterQRFlow {
    
    enum Update {
        
        struct Request {}
        
        struct Response {
            let isNextStepButtonActive: Bool
        }
        
        typealias ViewModel = EnterPasswordAfterQRModel.ViewModel
    }
    
    enum RoutePayload {
        
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }

    enum ChangeButtonState {

        struct Request {}

        struct Response {
            let isActive: Bool
        }

        struct ViewModel {}
    }

    enum OnDidLoadViews {
        
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }
    
    enum OnSelectItem {
        
        struct Request {
            let id: AnyHashable
            let selectedString: String?
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
//            let transportError: TransportError
        }
        
        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}
