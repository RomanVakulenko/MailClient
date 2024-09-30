//
//  ContactService.swift
// 31.07.2024.
//

import Foundation

protocol ContactServiceProtocol {
    func addContact(_ contact: ContactListItem, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllContacts(completion: @escaping (Result<[ContactListItem], Error>) -> Void)
    func searchContacts(by query: String, completion: @escaping (Result<[ContactListItem], Error>) -> Void)
    func updateContact(_ contact: ContactListItem, completion: @escaping (Result<ContactListItem, Error>) -> Void)
    func deleteContact(byUID uid: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class ContactService: ContactServiceProtocol {
    static let shared: ContactServiceProtocol = ContactService()
    private init() {}
    
    private let database = DIManager.shared.container.resolve(ContactDatabaseProtocol.self)!
    private let network = DIManager.shared.container.resolve(NetworkManaging.self)!
    private let storage = DIManager.shared.container.resolve(StorageProtocol.self)!
    
    func addContact(_ contact: ContactListItem, completion: @escaping (Result<Void, Error>) -> Void) {
        database.addContact(contact, completion: completion)
    }
    
    func getAllContacts(completion: @escaping (Result<[ContactListItem], Error>) -> Void) {
        database.getAllContacts(completion: completion)
    }
    
    func searchContacts(by query: String, completion: @escaping (Result<[ContactListItem], Error>) -> Void) {
        database.searchContacts(by: query, completion: completion)
    }
    
    func updateContact(_ contact: ContactListItem, completion: @escaping (Result<ContactListItem, Error>) -> Void) {
        database.updateContact(contact, completion: completion)
    }
    
    func deleteContact(byUID uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        database.deleteContact(byUID: uid, completion: completion)
    }
}
