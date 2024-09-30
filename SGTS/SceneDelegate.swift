//
//  SceneDelegate.swift
// 01.04.2024.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let network = DIManager.shared.container.resolve(NetworkManaging.self)!
    private let storage = DIManager.shared.container.resolve(StorageProtocol.self)!
    private let secretStorage = DIManager.shared.container.resolve(SecretStorageProtocol.self)!
    private let cryptoLayer = DIManager.shared.container.resolve(CryptoLayerProtocol.self)!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let initialController = InitialBuilder().getController()
        window.rootViewController = initialController
        self.window = window

        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            let url = context.url
            print("scene openURLContexts called with URL: \(url)")
            if url.scheme?.lowercased() == secretStorage.deepLinkSheme.lowercased() {
                handleDeepLink(url: url)
            }
        }
    }

    private func handleDeepLink(url: URL) {
//        let host = url.host
//        let pathComponents = url.pathComponents

        // Разбор URL на компоненты
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryParams: [String: String] = [:]

        // Извлечение параметров запроса
        urlComponents?.queryItems?.forEach {
            queryParams[$0.name] = $0.value
        }
        
        // Логика обработки deep link
        //...
    }

    private func showAlertOnActiveController() {
        if let currentController = storage.getCurrentControllerLink() {
            let alert = UIAlertController(title: "", 
                                          message: "password error ",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", 
                                          style: .default,
                                          handler: { _ in
            }))
            currentController.present(alert, 
                                      animated: true,
                                      completion: nil)
        }
    }
    
    private func openSetPinCodeScreen() {
        let setPinCodeController = SetPinCodeBuilder().getController()
        if let currentController = storage.getCurrentControllerLink() {
            currentController.navigationController?.pushViewController(setPinCodeController,
                                                                       animated: false)
        }
    }
    
}
