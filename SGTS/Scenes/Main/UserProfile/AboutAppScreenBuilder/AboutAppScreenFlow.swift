//
//  AboutAppScreenFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import Foundation

enum AboutAppScreenFlow {
    
    enum Update {
        
        struct Request {}
        
        struct Response {}

        typealias ViewModel = AboutAppScreenViewModel
    }

    enum OnDidLoadViews {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnTextFieldDidChange {

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
        
        struct Response {}
        
        struct ViewModel {}
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
