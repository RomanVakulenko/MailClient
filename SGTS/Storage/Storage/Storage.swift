//
//  Storage.swift
// 31.05.2024.
//

import Foundation
import UIKit

protocol StorageProtocol: AnyObject {
    // Методы сохранения
    func save(sk: String)
    func save(callbackCode: String)
    func save(callbackState: String)
    func save(containerCN: String)
    func save(containerSerialNumber: String)
    func save(containerMail: String)
    func save(containerO: String)
    func save(containerC: String)
    func savePinCode(_ pinCode: String)
    func saveContainerPassword(password: String)
    func save(token: String)
    func save(tokenExpire: String)
    func save(isFaceIdEnable: Bool)
    
    // Методы загрузки
    func loadSk() -> String?
    func loadCallbackCode() -> String?
    func loadCallbackState() -> String?
    func loadContainerCN() -> String?
    func loadContainerSerialNumber() -> String?
    func loadContainerMail() -> String?
    func loadContainerO() -> String?
    func loadContainerC() -> String?
    func loadPinCode() -> String?
    func loadToken() -> String?
    func loadTokenExpire() -> String?
    func loadContainerPassword() -> String?
    func loadIsFaceIdEnable() -> Bool
    
    // Универсальные методы сохранения и загрузки данных
    func save<T: Encodable>(_ object: T, key: String)
    func load<T: Decodable>(_ key: String) -> T?
    func remove(_ key: String)
    
    // Метод для получения идентификатора приложения
    func getAppID() -> String
    
    // Методы работы с контактами
    func getContact(by identifier: String) -> ContactWithCert?
    func uploadContact(_ contact: ContactWithCert)
    
    // Методы для работы с текущим контроллером
    func getCurrentControllerLink() -> UIViewController?
    func setCurrentControllerLink(_ controller: UIViewController)
}


class Storage: StorageProtocol {
    
    static let shared: StorageProtocol = Storage()
    
    private init() {}
    
    internal let queue = DispatchQueue(label: "ru.ContactManagerQueue", attributes: .concurrent)
    internal var contacts: [ContactWithCert] = []
    private let secretStorage = DIManager.shared.container.resolve(SecretStorageProtocol.self)!

    private weak var currentControllerLink: UIViewController?
    
    // Методы для работы с текущим контроллером
    func getCurrentControllerLink() -> UIViewController? {
        return currentControllerLink
    }
    
    func setCurrentControllerLink(_ controller: UIViewController) {
        currentControllerLink = controller
    }
    
// Save
    func save(sk: String) {
        _ = KeychainService.set(sk, forKey: getAppUID() + GlobalConstants.keySK)
    }
    
    func save(callbackCode: String) {
        _ = KeychainService.set(callbackCode, forKey: getAppUID() + GlobalConstants.keyCallbackCode)
    }
    
    func save(callbackState: String) {
        _ = KeychainService.set(callbackState, forKey: getAppUID() + GlobalConstants.keyCallbackState)
    }
    
    
    func save(containerCN: String) {
        _ = KeychainService.set(containerCN, forKey: getAppUID() + GlobalConstants.keyFromContainerCN)
    }
    
    func save(containerSerialNumber: String) {
        _ = KeychainService.set(containerSerialNumber, forKey: getAppUID() + GlobalConstants.keyFromContainerSerialNumber)
    }
    
    func save(containerMail: String) {
        _ = KeychainService.set(containerMail, forKey: getAppUID() + GlobalConstants.keyFromContainerMail)
    }
    
    func save(containerO: String) {
        _ = KeychainService.set(containerO, forKey: getAppUID() + GlobalConstants.keyFromContainerO)
    }
    
    func save(containerC: String) {
        _ = KeychainService.set(containerC, forKey: getAppUID() + GlobalConstants.keyFromContainerC)
    }
    
    func savePinCode(_ pinCode: String) {
        _ = KeychainService.set(pinCode, forKey: getAppUID() + GlobalConstants.keyToSavePinCode)
    }
    
    func saveContainerPassword(password: String) {
        _ = KeychainService.set(password, forKey: getAppUID() + GlobalConstants.keyFromContainerPassword)
    }
    
    func save(token: String) {
        _ = KeychainService.set(token, forKey: getAppUID() + GlobalConstants.keyFromToken)
    }
    
    func save(tokenExpire: String) {
        _ = KeychainService.set(tokenExpire, forKey: getAppUID() + GlobalConstants.keyFromTokenExpire)
    }
    
    func save(isFaceIdEnable: Bool) {
        _ = KeychainService.set(isFaceIdEnable, forKey: getAppUID() + GlobalConstants.keyFromIsFaceIdEnable)
    }
    
// Load
    func loadSk() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keySK)
    }
    
    func loadCallbackCode() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyCallbackCode)
    }
    
    func loadCallbackState() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyCallbackState)
    }
    
    func loadContainerCN() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyFromContainerCN)
    }
    
    func loadContainerSerialNumber() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyFromContainerSerialNumber)
    }
    
    func loadContainerMail() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyFromContainerMail)
    }
    
    func loadContainerO() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyFromContainerO)
    }
    
    func loadContainerC() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyFromContainerC)
    }
    
    func loadPinCode() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyToSavePinCode)
    }
    
    func loadToken() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyFromToken)
    }
    
    func loadTokenExpire() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyFromTokenExpire)
    }
    
    func loadContainerPassword() -> String? {
        return KeychainService.get(forKey: getAppUID() + GlobalConstants.keyFromContainerPassword)
    }
    
    func loadIsFaceIdEnable() -> Bool {
        return KeychainService.getBool(forKey: getAppUID() + GlobalConstants.keyFromIsFaceIdEnable) ?? false
    }
    
    func getAppID() -> String {
        return secretStorage.appID
    }
    
    private func getAppUID() -> String {
        if let uid = UserDefaults.standard.string(forKey: GlobalConstants.keyFromAppUID) {
            return uid
        } else {
            let uid = UUID().uuidString
            UserDefaults.standard.set(uid, forKey: GlobalConstants.keyFromAppUID)
            return uid
        }
    }
    
    func save<T: Encodable>(_ object: T, key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func load<T: Decodable>(_ key: String) -> T? {
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(T.self, from: data) {
                return object
            }
        }
        return nil
    }
    
    func remove(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
