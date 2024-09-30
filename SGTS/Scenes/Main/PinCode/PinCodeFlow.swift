//
//  PinCodeFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import Foundation

enum PinCodeFlow {
    
    enum Update {

        enum PinState {
            case notEntering, entering, ok, bad, deleteOneDigit
        }

        struct Request {}

        struct Response {
            let pinState: PinState
            let amountOfEnteredDigits: Int
//            let enteredPinDigitsArr: [Int] //это второй параметр?
        }
        
        typealias ViewModel = PinCodeModel.ViewModel
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

    enum OnFaceDetection {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }
    
    enum OnSelectItem {
        
        struct Request {
            let id: AnyHashable
            let selectedString: String?
            let selectedIndex: Int?
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
        
        struct Request {
            let error: PinCodeModel.Errors
        }
        
        struct Response {
//            let transportError: TransportError
            let error: PinCodeModel.Errors
        }
        
        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}
