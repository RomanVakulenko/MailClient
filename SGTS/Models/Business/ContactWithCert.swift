//
//  ContactWithCert.swift
// 21.06.2024.
//

import Foundation

// Business model for ContactMeta
struct ContactMeta {
    let avatar: String?
    let cn: String?
    let email: String?
    let fname: String?
    let iin: String?
    let phone: String?
    let sname: String?
    let ssn: String?
    let subject: String?
    let uid: String
    let xsn: String?
    
    init(avatar: String? = nil,
         cn: String? = nil,
         email: String? = nil,
         fname: String? = nil,
         iin: String? = nil,
         phone: String? = nil,
         sname: String? = nil,
         ssn: String? = nil,
         subject: String? = nil,
         uid: String,
         xsn: String? = nil) {
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
    
    // Initializer from DTO
    init(dto: Reply.Mail.ContactMetaDTO) {
        self.avatar = dto.avatar
        self.cn = dto.cn
        self.email = dto.email
        self.fname = dto.fname
        self.iin = dto.iin
        self.phone = dto.phone
        self.sname = dto.sname
        self.ssn = dto.ssn
        self.subject = dto.subject
        self.uid = dto.uid ?? ""
        self.xsn = dto.xsn
    }
}

// Business model for ContactInfo
struct ContactInfo {
    let contactMail: String?
    let elapsedTime: Int?
    let meta: ContactMeta
    let reqId: String
    let status: String
    let version: String
    
    init(contactMail: String? = nil,
         elapsedTime: Int? = nil,
         meta: ContactMeta,
         reqId: String,
         status: String,
         version: String) {
        self.contactMail = contactMail
        self.elapsedTime = elapsedTime
        self.meta = meta
        self.reqId = reqId
        self.status = status
        self.version = version
    }
    
    // Initializer from DTO
    init(dto: Reply.Mail.ContactInfoDTO) {
        self.contactMail = dto.contactMail
        self.elapsedTime = dto.elapsedTime
        self.meta = ContactMeta(dto: dto.meta ?? Reply.Mail.ContactMetaDTO(avatar: nil, cn: nil, email: nil, fname: nil, iin: nil, phone: nil, sname: nil, ssn: nil, subject: nil, uid: nil, xsn: nil))
        self.reqId = dto.reqId ?? ""
        self.status = dto.status ?? ""
        self.version = dto.version ?? ""
    }
}

struct Certificates: Decodable {
    let version: String?
    let status: String?
    let cert_sign: String
    let cert_xchg: String
    
    init(version: String?, status: String?, cert_sign: String, cert_xchg: String) {
        self.version = version
        self.status = status
        self.cert_sign = cert_sign
        self.cert_xchg = cert_xchg
    }
    
    init(dto: Reply.Auth.CertificatesDTO) {
        self.version = dto.version
        self.status = dto.status
        self.cert_sign = dto.cert_sign
        self.cert_xchg = dto.cert_xchg
    }
}


struct ContactWithCert {
    var info: ContactMeta
    var certs: Certificates?
}
