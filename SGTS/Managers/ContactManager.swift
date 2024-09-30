//
//  ContactManager.swift
// 31.07.2024.
//

import Foundation

protocol ContactManagerProtocol {
    func addContact(_ contact: ContactListItem, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllContacts(completion: @escaping (Result<[ContactListItem], Error>) -> Void)
    func searchContacts(by query: String, completion: @escaping (Result<[ContactListItem], Error>) -> Void)
    func updateContact(_ contact: ContactListItem, completion: @escaping (Result<ContactListItem, Error>) -> Void)
    func deleteContact(byUID uid: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class ContactManager: ContactManagerProtocol {
    static let shared: ContactManagerProtocol = ContactManager()
    private let contactService = DIManager.shared.container.resolve(ContactServiceProtocol.self)!
    
    private init() {}
    
    func addContact(_ contact: ContactListItem, completion: @escaping (Result<Void, Error>) -> Void) {
        contactService.addContact(contact, completion: completion)
    }
    
    func getAllContacts(completion: @escaping (Result<[ContactListItem], Error>) -> Void) {
        contactService.getAllContacts(completion: completion)
    }
    
    func searchContacts(by query: String, completion: @escaping (Result<[ContactListItem], Error>) -> Void) {
        contactService.searchContacts(by: query, completion: completion)
    }
    
    func updateContact(_ contact: ContactListItem, completion: @escaping (Result<ContactListItem, Error>) -> Void) {
        contactService.updateContact(contact, completion: completion)
    }
    
    func deleteContact(byUID uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        contactService.deleteContact(byUID: uid, completion: completion)
    }
}
