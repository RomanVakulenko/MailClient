//
//  TabBarController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.06.2024.
//

import UIKit


final class TabBarController: UITabBarController {
    
    private let userNotificationManager = DIManager.shared.container.resolve(UserNotificationManagerProtocol.self)!
    // MARK: - Public properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Private properties

    private let contactManager = DIManager.shared.container.resolve(ContactManagerProtocol.self)!
    private let webSocketManager = DIManager.shared.container.resolve(WebSocketControlProtocol.self)!
    private let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!

    // MARK: - Lifecycle

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
        observeThemeChanging()
        observeLangChanging()
        
        contactManager.getAllContacts { result in
            switch result {
            case .success(let contacts):
                if contacts.count == 0 {
                    ContactSearcher.shared.startSearching()
                }
            case .failure(let error):
                print("Failed to get contacts: \(error.localizedDescription)")
            }
        }
        webSocketManager.runWebSocketConnectionIfNeeded()
    }

    // MARK: - Private methods

    private func setupTabBarController() {
        delegate = self
        UITabBar.appearance().backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        viewControllers = createChildViewControllers()
    }

    private func createChildViewControllers() -> [UIViewController] {
        let mailVC = createMailStartScreenVC()
        let userProfileVC = createUserProfileScreenVC()
        return [mailVC, userProfileVC]
    }

    private func updateTabBar() {
        UITabBar.appearance().backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        if Theme.shared.isLight {
            self.tabBarItem.setTitleTextAttributes([.font: UIHelper.Font.RobotoRegular12, .foregroundColor: UIHelper.Color.grayL], for: .normal)
            if let items = self.tabBarController?.tabBar.items {
                for (index, item) in items.enumerated() {
                    switch index {
                    case 0:
                        item.title = getString(.emailsTabBarItemTitle)
                    case 1:
                        item.title = getString(.userProfileTitle)
                    default:
                        break
                    }
                }
            }
        } else {
            self.tabBarItem.setTitleTextAttributes([.font: UIHelper.Font.RobotoRegular12, .foregroundColor: UIHelper.Color.whiteStrong], for: .normal) //TODO: цвет для темной темы
        }
    }
}

// MARK: - Creating ViewControllers

extension TabBarController {

    private func createMailStartScreenVC() -> UIViewController {
        let mailStartScreenVC = MailStartScreenBuilder().getControllerFor(messageType: .incoming)
        let mailNavController = CustomNavigationController(rootViewController: mailStartScreenVC)

        TabBarManager.configureTabBarItem(
            for: mailNavController,
            title: TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .incoming).0,
            image: TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .incoming).1,
            selectedImage: TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .incoming).2)
        return mailNavController
    }

    private func createUserProfileScreenVC() -> UIViewController {
        let userProfileScreenVC = UserProfileBuilder().getController()
        let userProfileNavController = UINavigationController(rootViewController: userProfileScreenVC)

        TabBarManager.configureTabBarItem(
            for: userProfileNavController,
            title: TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .userNameAndEmail).0,
            image: TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .userNameAndEmail).1,
            selectedImage: TabBarManager.makeTitleImageAndSelectedImageForTabItem(messageType: .userNameAndEmail).2)
        return userProfileNavController
    }
}


// MARK: - Theme and Language changing

extension TabBarController {

    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.updateTabBar()
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.updateTabBar()
            }
    }
}


// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == getString(.emailsTabBarItemTitle) {
            NotificationCenter.default.post(name: .mailStartScreenSelected, object: nil)
        } else if item.title == getString(.userProfileTitle) {
            NotificationCenter.default.post(name: .userProfileScreenSelected, object: nil)
        }
    }
}

