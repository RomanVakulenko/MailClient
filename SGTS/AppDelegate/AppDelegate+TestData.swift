//
//  AppDelegate+TestData.swift
// 05.08.2024.
//

import UIKit

extension AppDelegate {
    func createTestData() {
        createEmails()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.readEmails()
        }
        generateTestContacts { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func createEmails() {
        let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!
        let folderName = GlobalConstants.inboxEmails

        // Стираем все письма из базы данных
        mailManager.getAllFolders { result in
            switch result {
            case .success(let folders):
                let group = DispatchGroup()
                for folder in folders {
                    group.enter()
                    mailManager.clearFolder(folder.name) { _ in
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    print("All emails cleared successfully.")
                    // Проверка наличия писем в базе
                    mailManager.getAllMails(page: 0, pageSize: 1) { result in
                        switch result {
                        case .success(let emails):
                            if emails.isEmpty {
                                // Если база пустая, создаем новую папку и добавляем письма
                                mailManager.createFolder(name: folderName) { result in
                                    switch result {
                                    case .success:
                                        print("Folder created successfully.")
                                        // После успешного создания папки, создаем и добавляем письма
                                        for i in 1...200 {
                                            let email = EmailMessage()
                                            email.date = Date()
                                            email.from = "sender\(i)@example.com"
                                            email.sender = "sender\(i)@example.com"
                                            email.to = "recipient\(i)@example.com"
                                            email.subject = "Test Email \(i)"
                                            email.mimeVersion = "1.0"
                                            email.contentType = "text/plain; charset=UTF-8"
                                            email.boundary = "boundary\(i)"
                                            email.contentTransferEncoding = "7bit"
                                            email.body = "This is the body of test email number \(i)"
                                            email.htmlBody = "<html><body>This is the <b>HTML body</b> of test email number \(i)</body></html>"
                                            email.messageId = UUID().uuidString
                                            email.isPrivate = i % 2 == 0
                                            email.isRead = i % 2 != 0
                                            email.userAgent = "Test User Agent \(i)"

                                            // Пример добавления CC, BCC, Reply-To
                                            let ccContact = ContactMail()
                                            ccContact.displayName = "CC User \(i)"
                                            ccContact.mailbox = "cc\(i)@example.com"
                                            email.cc.append(ccContact)

                                            let bccContact = ContactMail()
                                            bccContact.displayName = "BCC User \(i)"
                                            bccContact.mailbox = "bcc\(i)@example.com"
                                            email.bcc.append(bccContact)

                                            let replyToContact = ContactMail()
                                            replyToContact.displayName = "Reply-To User \(i)"
                                            replyToContact.mailbox = "replyto\(i)@example.com"
                                            email.replyTo.append(replyToContact)

                                            // Пример вложения
                                            if i % 3 == 0 {
                                                // С вложениями
                                                let attachment1 = Attachment()
                                                attachment1.filename = "attachment\(i).txt"
                                                attachment1.mimeType = "text/plain"
                                                attachment1.content = "This is the content of attachment \(i)".data(using: .utf8) ?? Data()

                                                let attachment2 = Attachment()
                                                attachment2.filename = "image\(i).png"
                                                attachment2.mimeType = "image/png"
                                                attachment2.content = UIImage(named: "exampleImage")?.pngData() ?? Data()

                                                let attachment3 = Attachment()
                                                attachment3.filename = "document\(i).pdf"
                                                attachment3.mimeType = "application/pdf"
                                                if let pdfPath = Bundle.main.path(forResource: "exampleDocument", ofType: "pdf"),
                                                   let pdfData = try? Data(contentsOf: URL(fileURLWithPath: pdfPath)) {
                                                    attachment3.content = pdfData
                                                }

                                                email.attachments.append(objectsIn: [attachment1, attachment2, attachment3])
                                            }
                                            
                                            
                                            if i % 6 == 0 || i % 2 == 0 {
                                                // С вложениями
                                                let attachment1 = Attachment()
                                                attachment1.filename = "image\(i).jpeg"
                                                attachment1.mimeType = "image/jpeg"
                                                attachment1.content = UIImage(named: "flatterShy.jpeg")?.pngData() ?? Data()
                                                
                                                let attachment2 = Attachment()
                                                attachment2.filename = "image\(i).png"
                                                attachment2.mimeType = "image/png"
                                                attachment2.content = UIImage(named: "pinkiPie.png")?.pngData() ?? Data()

                                                let attachment3 = Attachment()
                                                attachment3.filename = "image\(i).jpg"
                                                attachment3.mimeType = "image/jpg"
                                                attachment3.content = UIImage(named: "myLittlePony.jpg")?.pngData() ?? Data()

                                                email.htmlInlineAttachments.append(objectsIn: [attachment1, attachment2, attachment3])
                                            }
                                            

                                            let mailBusinessModel = EmailMessageModel(dto: email)
                                            mailManager.addMail(mailBusinessModel, toFolder: folderName) { result in
                                                switch result {
                                                case .success:
                                                    print("Email \(i) added successfully.")
                                                case .failure(let error):
                                                    print("Failed to add email \(i): \(error.localizedDescription)")
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        print("Failed to create folder: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                print("Database already contains emails.")
                            }
                        case .failure(let error):
                            print("Failed to check emails: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Failed to get folders: \(error.localizedDescription)")
            }
        }
    }
    
    private func readEmails() {
        let mailManager = MailManager.shared
        let pageSize = 10
        var page = 0
        
        func fetchPage() {
            mailManager.getAllMails(page: page, pageSize: pageSize) { result in
                switch result {
                case .success(let emails):
                    if emails.isEmpty {
                        print("No more emails to fetch.")
                        return
                    }
                    for email in emails {
                        print("From: \(email.from)")
                        print("To: \(email.to)")
                        print("Subject: \(email.subject)")
                        print("Body: \(email.body)")
                        print("Date: \(email.date)")
                        print("Attachments: \(email.attachments.count)")
                        print("---------------------------")
                    }
                    page += 1
                    fetchPage() // Fetch next page
                case .failure(let error):
                    print("Failed to fetch emails: \(error.localizedDescription)")
                }
            }
        }
        
        fetchPage() // Start fetching from the first page
    }

    private func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    private func generateRandomEmail() -> String {
        let emailDomain = ["example.com", "test.com", "email.com", "mail.com"]
        let emailUser = generateRandomString(length: 8)
        let domain = emailDomain.randomElement()!
        return "\(emailUser)@\(domain)"
    }

    private func generateTestContacts(completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        let contactManager = DIManager.shared.container.resolve(ContactManagerProtocol.self)!
        
        for _ in 1...200 {
            dispatchGroup.enter()
            let avatar = "none"
//            let cn = generateRandomString(length: 10)
            let email = generateRandomEmail()
            let fname = generateRandomString(length: 8)
            let iin = "\(100000000000 + Int.random(in: 1..<999999999999))"
            let phone = "+12345" + generateRandomString(length: 5)
            let sname = generateRandomString(length: 8)
            let cn = "\(fname) \(sname)"
            let ssn = generateRandomString(length: 64)
            let subject = "E=\(email);SERIALNUMBER=IIN\(iin);CN=\(cn);O=TestCompany;C=TestCountry"
            let uid = "\(100000000000 + Int.random(in: 1..<999999999999))"
            let xsn = generateRandomString(length: 64)
            
            let contact = ContactListItem(
                avatar: avatar,
                cn: cn,
                email: email,
                fname: fname,
                iin: iin,
                phone: phone,
                sname: sname,
                ssn: ssn,
                subject: subject,
                uid: uid,
                xsn: xsn
            )
            
            contactManager.addContact(contact) { result in
                switch result {
                case .success:
                    print("Successfully added contact \(contact.cn)")
                case .failure(let error):
                    print("Failed to add contact \(contact.cn): \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
}
