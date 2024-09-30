//
//  SideMenuFlow.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import UIKit

enum SideMenuFlow {

    enum Update {

        struct Request {}

        struct Response {
            let userFullName: String
            let userEmail: String
            let incomingMessagesAmountOfTotal: String
            let incomingMessagesTotal: String
            let sentMessagesTotal: String
            let outgoingMessagesTotal: String
            let draftsMessagesTotal: String
            let archivedMessagesTotal: String
            let deletedMessagesTotal: String
            let typeOfUpdate: SideMenuModel.TypeOfUpdate
        }

        typealias ViewModel = SideMenuModel.ViewModel
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
