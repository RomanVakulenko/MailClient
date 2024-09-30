//
//  DIManager.swift
// 21.07.2024.
//

import Swinject

final class DIManager {
    
    // MARK: - Public properties
    static let shared = DIManager()
    let container: Container
    
    // MARK: - Private properties
    private init() {
        container = Container()
        registerDependencies()
    }
    
    private func registerDependencies() {
        container.register(NetworkManaging.self) { _ in
            NetworkManager()
        }
        container.register(EmailManagerProtocol.self) { _ in
            MailManager.shared
        }.inObjectScope(.container)
        
        container.register(MailDatabaseProtocol.self) { _ in
            MailDatabaseService.shared
        }.inObjectScope(.container)
        
        container.register(ContactDatabaseProtocol.self) { _ in
            MailDatabaseService.shared
        }.inObjectScope(.container)
        
        container.register(FileServiceProtocol.self) { _ in
            FileService()
        }
        
        container.register(StorageProtocol.self) { _ in
            Storage.shared
        }.inObjectScope(.container)
        
        container.register(FileServiceProtocol.self) { _ in
            FileService()
        }.inObjectScope(.container)
        
        container.register(OpenFileManagerProtocol.self) { _ in
            OpenFileManager.shared
        }.inObjectScope(.container)
        
        container.register(ContactServiceProtocol.self) { _ in
            ContactService.shared
        }.inObjectScope(.container)
        
        container.register(ContactManagerProtocol.self) { _ in
            ContactManager.shared
        }.inObjectScope(.container)
        
        container.register(SecretKeySelectorBuilderProtocol.self) { _ in
            SecretKeySelectorBuilder()
        }
        
        container.register(UserNotificationServiceProtocol.self) { _ in
            UserNotificationService.shared
        }.inObjectScope(.container)
        
        container.register(UserNotificationManagerProtocol.self) { _ in
            UserNotificationManager.shared
        }.inObjectScope(.container)
        
        container.register(MailServiceProtocol.self) { _ in
            MailService.shared
        }.inObjectScope(.container)
        
        
        container.register(WebSocketServiceProtocol.self) { _ in
            WebSocketService()
        }
        
        container.register(WebSocketControlProtocol.self) { _ in
                MockWebSocketManager.shared
        }.inObjectScope(.container)
        
        container.register(SecretStorageProtocol.self) { _ in
                MockSecretStorage.shared
        }.inObjectScope(.container)
        
        container.register(CryptoLayerProtocol.self) { _ in
                MockCryptoLayer.shared
        }.inObjectScope(.container)
        
        container.register(UserProfileStoreProtocol.self) { _ in
            UserProfileStore.shared
        }.inObjectScope(.container)
        
    }
}
