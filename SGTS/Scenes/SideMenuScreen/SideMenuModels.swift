//
//  SideMenuModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import DifferenceKit
import UIKit

enum SideMenuModel {

    struct ViewModel {
        var grayViewColor: UIColor
        var items: [AnyDifferentiable]
    }

    struct ItemViewModel {
        var items: [AnyDifferentiable]
    }
    
    enum TypeOfUpdate {
        case allScreenWithAllCounts
        case withZeros
        case incomingCount
        case otherCount
    }

    enum MenuItems: String {
        case userNameAndEmail

        case incoming
        case sent
        case outgoing

        case drafts
        case archived
        case deleted

        case attachments
        case settings
        case searchContactsAtServer
    }

    static func makeTitleFor(messageType: MenuItems) -> String {
        switch messageType {
        case .incoming:
            return getString(.mailStartScreenTitle)

        case .sent:
            return getString(.alreadySentMessage)

        case .outgoing:
            return getString(.outgoingMessages)

        case .drafts:
            return getString(.draftMessages)

        case .archived:
            return getString(.archivedMessages)

        case .deleted:
            return getString(.deletedMessages)

        case .attachments:
            return getString(.attachmentsTitle)

        case .settings:
            return getString(.settingsTitle)

        case .searchContactsAtServer:
            return getString(.searchTitleForTabBarItem)

        default:
            return ""
        }
    }
}
