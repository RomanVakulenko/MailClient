//
//  UserProfileChangePinCodeFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import Foundation

enum UserProfileChangePinCodeFlow {

    enum Update {

        struct Request {}

        struct Response {
            let isConfirmPasswordActive: Bool
            let isBiometrySwitchActive: Bool
            let isBiometrySwitchOn: Bool
            let isFinishButtonActive: Bool
            let currentPassword: String?
            let newPassword: String?
        }

        typealias ViewModel = UserProfileChangePinCodeModel.ViewModel
    }

    enum RoutePayload {

        struct Request {}

        struct Response {}

        struct ViewModel {}
    }

    enum ChangeConfirmPswrdState {

        struct Request {}

        struct Response {
            let isActive: Bool
        }

        struct ViewModel {}
    }

    enum ChangeButtonState {

        struct Request {}

        struct Response {
            let isActive: Bool
        }

        struct ViewModel {}
    }

    enum ChangeSwitchState {

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

    enum OnSwitchTap {

        struct Request {
            let isOn: Bool
        }

        struct Response {
            let isOn: Bool
        }

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
            let error: Error
        }

        struct ViewModel {
            let title: String?
            let text: String?
            let buttonTitle: String?
        }
    }
}

