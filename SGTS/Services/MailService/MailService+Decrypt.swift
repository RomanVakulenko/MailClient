//
//  MailService+Decrypt.swift
// 30.07.2024.
//

import Foundation

extension MailService {
    
    // MARK: - fetchPrivateEmail
    internal func fetchPrivateEmail(source: MailDTO, completion: @escaping (Data?) -> Void) {
        guard storage.loadToken() != nil,
              source.fileName != nil
        else {
            completion(nil)
            return
        }
        completion(nil)
    }
    
    func saveUserDataToFile(userData: Reply.Mail.DataWithCertsDTO, fileName: String) -> URL? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(userData)
            return saveFileToDownloads(data: data, fileName: fileName)
        } catch {
            print("Ошибка при кодировании данных: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func decryptFile(fileHeaders: Reply.Mail.DataWithCertsDTO, sourceData: Data) -> Data? {
        return nil
    }
    
    func getContactInfo(senderMail: String, completion: @escaping (Result <Void, Error>) -> Void) {

    }
    
    internal func getCertByUID(token: String, uid: String, completion: @escaping (Result <Void, Error>) -> Void) {
    }

}
