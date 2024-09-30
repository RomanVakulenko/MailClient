//
//  ContactListItem.swift
// 31.07.2024.
//

struct ContactListItem: Hashable {
    let avatar: String
    let cn: String
    let email: String
    let fname: String
    let iin: String
    let phone: String
    let sname: String
    let ssn: String
    let subject: String
    let uid: String
    let xsn: String
    
    init(avatar: String = "",
         cn: String = "",
         email: String = "",
         fname: String = "",
         iin: String = "",
         phone: String = "",
         sname: String = "",
         ssn: String = "",
         subject: String = "",
         uid: String = "",
         xsn: String = "") {
        self.avatar = avatar
        self.cn = cn
        self.email = email
        self.fname = fname
        self.iin = iin
        self.phone = phone
        self.sname = sname
        self.ssn = ssn
        self.subject = subject
        self.uid = uid
        self.xsn = xsn
    }

    init(withEmailLowercased contact: ContactListItem) {
           self.avatar = contact.avatar
           self.cn = contact.cn
           self.email = contact.email.lowercased()
           self.fname = contact.fname
           self.iin = contact.iin
           self.phone = contact.phone
           self.sname = contact.sname
           self.ssn = contact.ssn
           self.subject = contact.subject
           self.uid = contact.uid
           self.xsn = contact.xsn
    }

    init(from dto: Reply.Mail.ContactListItemDTO) {
        self.avatar = dto.avatar ?? ""
        self.cn = dto.cn ?? ""
        self.email = dto.email ?? ""
        self.fname = dto.fname ?? ""
        self.iin = dto.iin ?? ""
        self.phone = dto.phone ?? ""
        self.sname = dto.sname ?? ""
        self.ssn = dto.ssn ?? ""
        self.subject = dto.subject ?? ""
        self.uid = dto.uid ?? ""
        self.xsn = dto.xsn ?? ""
    }
    
    init(from databaseDTO: ContactListItemDatabaseDTO) {
        self.avatar = databaseDTO.avatar
        self.cn = databaseDTO.cn
        self.email = databaseDTO.email
        self.fname = databaseDTO.fname
        self.iin = databaseDTO.iin
        self.phone = databaseDTO.phone
        self.sname = databaseDTO.sname
        self.ssn = databaseDTO.ssn
        self.subject = databaseDTO.subject
        self.uid = databaseDTO.uid
        self.xsn = databaseDTO.xsn
    }
    
    static func == (lhs: ContactListItem, rhs: ContactListItem) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
