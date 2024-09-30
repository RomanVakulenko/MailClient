//
//  MailDatabaseService+Contact.swift
// 31.07.2024.
//

import Foundation
import RealmSwift

protocol ContactDatabaseProtocol {
    func addContact(_ contact: ContactListItem, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllContacts(completion: @escaping (Result<[ContactListItem], Error>) -> Void)
    func searchContacts(by query: String, completion: @escaping (Result<[ContactListItem], Error>) -> Void)
    func updateContact(_ contact: ContactListItem, completion: @escaping (Result<ContactListItem, Error>) -> Void)
    func deleteContact(byUID uid: String, completion: @escaping (Result<Void, Error>) -> Void)
}

extension MailDatabaseService: ContactDatabaseProtocol {
    
    func addContact(_ contact: ContactListItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Adding contact with uid: \(contact.uid)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    do {
                        let contactDTO = ContactListItemDatabaseDTO(from: contact)
                        try realm.write {
                            realm.add(contactDTO)
                        }
                        Log.i("Contact with uid \(contact.uid) added successfully")
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } catch {
                        Log.e("Failed to add contact with uid \(contact.uid): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for adding contact with uid \(contact.uid): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getAllContacts(completion: @escaping (Result<[ContactListItem], Error>) -> Void) {
        Log.i("Fetching all contacts")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    let contacts = realm.objects(ContactListItemDatabaseDTO.self)
                        .map { ContactListItem(from: $0) }
                    Log.i("Fetched \(contacts.count) contacts")
                    DispatchQueue.main.async {
                        completion(.success(Array(contacts)))
                    }
                case .failure(let error):
                    Log.e("Failed to fetch contacts: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func searchContacts(by query: String, completion: @escaping (Result<[ContactListItem], Error>) -> Void) {
        Log.i("Searching contacts with query: \(query)")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    let contacts = realm.objects(ContactListItemDatabaseDTO.self).filter(
                        "cn CONTAINS[c] %@ OR email CONTAINS[c] %@ OR fname CONTAINS[c] %@ OR iin CONTAINS[c] %@ OR phone CONTAINS[c] %@ OR sname CONTAINS[c] %@",
                        query, query, query, query, query, query
                    ).map { ContactListItem(from: $0) }
                    Log.i("Found \(contacts.count) contacts with query \(query)")
                    DispatchQueue.main.async {
                        completion(.success(Array(contacts)))
                    }
                case .failure(let error):
                    Log.e("Failed to search contacts with query \(query): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateContact(_ contact: ContactListItem, completion: @escaping (Result<ContactListItem, Error>) -> Void) {
        Log.i("Updating contact with uid: \(contact.uid)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    do {
                        if let existingContact = realm.objects(ContactListItemDatabaseDTO.self).filter("uid == %@", contact.uid).first {
                            try realm.write {
                                existingContact.avatar = contact.avatar
                                existingContact.cn = contact.cn
                                existingContact.email = contact.email
                                existingContact.fname = contact.fname
                                existingContact.iin = contact.iin
                                existingContact.phone = contact.phone
                                existingContact.sname = contact.sname
                                existingContact.ssn = contact.ssn
                                existingContact.subject = contact.subject
                                existingContact.xsn = contact.xsn
                            }
                            Log.i("Contact with uid \(contact.uid) updated successfully")
                            DispatchQueue.main.async {
                                completion(.success(ContactListItem(from: existingContact)))
                            }
                        } else {
                            Log.e("Contact with uid \(contact.uid) not found")
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Contact not found"])))
                            }
                        }
                    } catch {
                        Log.e("Failed to update contact with uid \(contact.uid): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for updating contact with uid \(contact.uid): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func deleteContact(byUID uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Deleting contact with uid: \(uid)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    do {
                        if let contact = realm.objects(ContactListItemDatabaseDTO.self).filter("uid == %@", uid).first {
                            try realm.write {
                                realm.delete(contact)
                            }
                            Log.i("Contact with uid \(uid) deleted successfully")
                            DispatchQueue.main.async {
                                completion(.success(()))
                            }
                        } else {
                            Log.e("Contact with uid \(uid) not found")
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Contact not found"])))
                            }
                        }
                    } catch {
                        Log.e("Failed to delete contact with uid \(uid): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for deleting contact with uid \(uid): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
