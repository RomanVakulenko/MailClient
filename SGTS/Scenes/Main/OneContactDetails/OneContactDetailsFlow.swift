//
//  OneContactDetailsFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 31.07.2024.
//

import Foundation

enum OneContactDetailsFlow {

    enum Update {

        struct Request {}
        
        struct Response {
            let id: String
            let fullName: String
            let emailAddress: String?
            let phoneNumber: String?
            let iin: String?
        }

        typealias ViewModel = OneContactDetailsModel.ViewModel
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

    enum OnTapEmailAddress {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }
    
    enum OnTapPhone {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum OnSelectItem {

        struct Request {
            let id: AnyHashable
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
