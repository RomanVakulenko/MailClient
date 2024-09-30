//
//  TabBarManager.swift
//  SGTS
//
//  Created by Roman Vakulenko on 10.07.2024.
//

import UIKit


enum TabBarManager {

    enum MessageType {
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

    static func makeTitleImageAndSelectedImageForTabItem(messageType: MessageType) -> (String, UIImage, UIImage) {
        switch messageType {
        case .userNameAndEmail:
            return (getString(.userProfileTitle),
                    Theme.shared.isLight ? UIHelper.Image.profileTabIconL : UIHelper.Image.profileTabIconL,
                    UIHelper.Image.profileTabIconSelected)
        case .incoming:
            return (getString(.mailStartScreenTitle),
                    Theme.shared.isLight ? UIHelper.Image.emailTabIcon24L : UIHelper.Image.emailTabIcon24D,
                    UIHelper.Image.emailTabIconSelected)
        case .sent:
            return (getString(.alreadySentMessage),
                    Theme.shared.isLight ? UIHelper.Image.sentIcon24L : UIHelper.Image.sentIcon24D,
                    UIHelper.Image.sentIcon24Blue)
        case .outgoing:
            return (getString(.outgoingMessages),
                    Theme.shared.isLight ? UIHelper.Image.outgoingIcon24L : UIHelper.Image.outgoingIcon24D,
                    UIHelper.Image.outgoingIcon24Blue)
        case .drafts:
            return (getString(.draftMessages),
                    Theme.shared.isLight ? UIHelper.Image.reportOrDraftIcon24L : UIHelper.Image.reportOrDraftIcon24D,
                    UIHelper.Image.reportOrDraftIcon24Blue)
        case .archived:
            return (getString(.archivedMessages),
                    Theme.shared.isLight ? UIHelper.Image.archiveIcon24x24L : UIHelper.Image.archiveIcon24x24D,
                    UIHelper.Image.archiveIcon24x24Blue)
        case .deleted:
            return (getString(.deletedMessages),
                    Theme.shared.isLight ? UIHelper.Image.trashIcon24x24L : UIHelper.Image.trashIcon24x24D,
                    UIHelper.Image.trashIcon24x24Blue)
        case .attachments:
            return (getString(.attachmentsTitle),
                    Theme.shared.isLight ? UIHelper.Image.sideMenuAttachmentIcon24L : UIHelper.Image.sideMenuAttachmentIcon24D,
                    UIHelper.Image.sideMenuAttachmentIcon24Blue)
        case .settings:
            return (getString(.settingsTitle),
                    Theme.shared.isLight ? UIHelper.Image.gearIcon24L : UIHelper.Image.gearIcon24D,
                    UIHelper.Image.gearIcon24Blue)
        case .searchContactsAtServer:
            return (getString(.searchTitleForTabBarItem),
                    Theme.shared.isLight ? UIHelper.Image.searchIcon24x24L : UIHelper.Image.searchIcon24x24D,
                    UIHelper.Image.searchIcon24x24Blue)
        }
    }

    static func configureTabBarItem(for navController: UINavigationController,
                                    title: String,
                                    image: UIImage,
                                    selectedImage: UIImage) {
        navController.setNavigationBarHidden(false, animated: true)

        navController.tabBarItem.title = title
        navController.tabBarItem.setTitleTextAttributes([.font: UIHelper.Font.RobotoRegular12, .foregroundColor: UIHelper.Color.grayL], for: .normal)
        navController.tabBarItem.setTitleTextAttributes([.font: UIHelper.Font.RobotoRegular12, .foregroundColor: UIHelper.Color.blue], for: .selected)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
    }

    static func hideAndDisableTabBarFor(navController: UIViewController) {
        navController.tabBarController?.tabBar.isHidden = true
    }

    static func showAndEnableTabBarFor(navController: UINavigationController) {
        navController.tabBarController?.tabBar.isHidden = false
    }
}
