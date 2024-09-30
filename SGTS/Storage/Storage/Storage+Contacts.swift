//
//  Storage+Contacts.swift
// 18.06.2024.
//

import Foundation

extension Storage {
    // Функция поиска ContactWithCert по полям uid, mail или iin
    func getContact(by identifier: String) -> ContactWithCert? {
        var foundContact: ContactWithCert?
        queue.sync {
            foundContact = contacts.first { contact in
                contact.info.uid == identifier || contact.info.email == identifier || contact.info.iin == identifier
            }
        }
        return foundContact
    }
    
    // Функция добавления или перезаписи ContactWithCert
    func uploadContact(_ contact: ContactWithCert) {
        queue.async(flags: .barrier) {
            if let index = self.contacts.firstIndex(where: { $0.info.uid == contact.info.uid }) {
                self.contacts[index] = contact
            } else {
                self.contacts.append(contact)
            }
        }
    }
}
