//
//  MailService+Attachments.swift
// 30.07.2024.
//

import Foundation

extension MailService {
    func loadAttachmentsContent(for email: EmailMessageModel, attempt: Int = 1, completion: @escaping (Result<EmailMessageModel, Error>) -> Void) {
        Log.i("Loading attachments content for mail: \(email.subject), attempt: \(attempt)")
        var updatedEmail = email
        var isError = false
        
        for i in 0..<updatedEmail.attachments.count {
            let fileName = updatedEmail.attachments[i].filenameToTemporarySave
            if let data = fileService.getAtContainer(fileName: fileName), !data.isEmpty {
                updatedEmail.attachments[i].content = data
            } else if updatedEmail.attachments[i].filenameToTemporarySave.isEmpty,
                      !updatedEmail.attachments[i].content.isEmpty {
                Log.i("Attachment has content for file: \(fileName)")
            } else {
                Log.e("Failed to load attachment content for file: \(fileName)")
                isError = true
            }
        }

        for i in 0..<updatedEmail.htmlInlineAttachments.count {
            let fileName = updatedEmail.htmlInlineAttachments[i].filenameToTemporarySave
            if let data = fileService.getAtContainer(fileName: fileName), !data.isEmpty {
                updatedEmail.htmlInlineAttachments[i].content = data
            } else if updatedEmail.htmlInlineAttachments[i].filenameToTemporarySave.isEmpty,
                      !updatedEmail.htmlInlineAttachments[i].content.isEmpty {
                Log.i("Attachment has inline content for file: \(fileName)")
            } else {
                Log.e("Failed to load attachment content for file: \(fileName)")
                isError = true
            }
        }

        if isError {
            Log.e("Failed to load attachment content for some files in mail: \(email.subject)")
            completion(.failure(NSError(domain: "Failed to load attachment content for file", code: 404, userInfo: nil)))
        } else {
            Log.i("Successfully loaded all attachments content for mail: \(email.subject)")
            completion(.success(updatedEmail))
        }
    }
}
