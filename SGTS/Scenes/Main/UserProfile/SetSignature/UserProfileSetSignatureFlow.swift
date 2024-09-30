//
//  UserProfileSetSignatureFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import Foundation

enum UserProfileSetSignatureFlow {

    enum Update {

        struct Request {}

        struct Response {
            let isFinishButtonActive: Bool //нужно? 
            let signature: String?
        }

        typealias ViewModel = UserProfileSetSignatureModel.ViewModel
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

    enum ChangeButtonState {

        struct Request {}

        struct Response {
            let isActive: Bool
        }

        struct ViewModel {}
    }

    enum OnSelectItem {

        struct Request {
            let id: AnyHashable
            let enteredText: String?
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
            let error: Error
        }

        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}

