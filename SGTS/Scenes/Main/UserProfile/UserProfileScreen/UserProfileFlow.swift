//
//  UserProfileFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import Foundation

enum UserProfileFlow {

    enum Update {

        struct Request {}

        struct Response { 
            let userFullName: String
            let userEmail: String
            let isDeleteFromServerOn: Bool
            let isUnsafeOutputAlertOn: Bool
            let isDarkThemeOn: Bool
        }

        typealias ViewModel = UserProfileModel.ViewModel
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

    enum OnSwitch {

        struct Request {
            let id: AnyHashable
            //            let isSwitchOn: Bool

        }

        struct Response {
            let isSwitchOn: Bool
        }

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
            let error: Error
        }

        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}

