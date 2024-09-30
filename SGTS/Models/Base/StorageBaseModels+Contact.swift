//
//  StorageBaseModels+Contact.swift
// 31.07.2024.
//

import Foundation
import RealmSwift

class ContactListItemDatabaseDTO: Object {
    @objc dynamic var avatar: String = ""
    @objc dynamic var cn: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var fname: String = ""
    @objc dynamic var iin: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var sname: String = ""
    @objc dynamic var ssn: String = ""
    @objc dynamic var subject: String = ""
    @objc dynamic var uid: String = ""
    @objc dynamic var xsn: String = ""
    
    // Конструктор из бизнес модели
    convenience init(from contact: ContactListItem) {
        self.init()
        self.avatar = contact.avatar
        self.cn = contact.cn
        self.email = contact.email
        self.fname = contact.fname
        self.iin = contact.iin
        self.phone = contact.phone
        self.sname = contact.sname
        self.ssn = contact.ssn
        self.subject = contact.subject
        self.uid = contact.uid
        self.xsn = contact.xsn
    }
}
