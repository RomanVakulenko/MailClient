//
//  InitialFlow.swift
// 01.04.2024.
//

import Foundation

enum InitialFlow {
    
    enum Update {
        
        struct Request {}
        
        struct Response {}
        
        typealias ViewModel = InitialModel.ViewModel
    }
    
    enum RoutePayload {
        
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }
    
    enum OnDidLoadViews {
        
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }

    enum OnDidAppear {

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
