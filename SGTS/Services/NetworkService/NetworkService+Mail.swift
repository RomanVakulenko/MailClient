//
//  NetworkService+Mail.swift
// 06.06.2024.
//

import Alamofire
import Foundation

protocol MailNetworkServicing {
    func getLettersList(token: String, parameters: Request.Auth.GetMailListRequestDTO, completion: @escaping (Result<Reply.Mail.MailHeadersResponse, Error>) -> Void)
    func getMailInfoById(token: String, mailId: String, folder: String, completion: @escaping (Result<Reply.Mail.MailInfoDTO, Error>) -> Void)
    func getFileBy(id: String, token: String, completion: @escaping (Result<Reply.Mail.DataWithCertsDTO, Error>) -> Void)
    func getUserInfoByMailAddress(token: String, mailAddress: String, completion: @escaping (Result<Reply.Mail.ContactInfoDTO, Error>) -> Void)
    func getUserCertByUID(token: String, uid: String, completion: @escaping (Result<Reply.Mail.ContactWithCert, Error>) -> Void)
    func getUserCertByIIN(token: String, iin: String)
    func searchContacts(searchQuery: String, token: String, completion: @escaping (Result<Reply.Mail.ContactSearchListResponseDTO, Error>) -> Void)
    func setMailStatus(parameters: Request.Mail.SetStaturRequestDTO, token: String, completion: @escaping () -> Void)
}

extension NetworkService: MailNetworkServicing {
    private enum EndpointName {
        static let getLettersList = "/somehost/restapi/mailservice/listall"
        static let getMailById = "/somehost/restapi/mailservicemail/getmail"
        static let getFileById = "/somehost/restapi/file/download/mail"
        static let getUserInfoByMailAddress = "/somehost/restapi/users/usermeta"
        static let getUserInfoBySN = "/somehost/restapi/certificarte/sn"
        static let getUserCertByUID = "/somehost/restapi/addresbook/getcard"
        static let getUserCertByIIN = "/somehost/restapi/certificarte/iin"
        static let searchContactByQuery = "/somehost/restapi/addresbook/search"
        static let setMailStatus = "/somehost/restapi/mailservice/setstatus"
    }

    func setMailStatus(parameters: Request.Mail.SetStaturRequestDTO, token: String, completion: @escaping () -> Void) {

    }
    
    func searchContacts(searchQuery: String, token: String, completion: @escaping (Result<Reply.Mail.ContactSearchListResponseDTO, Error>) -> Void) {

    }
    
    func getUserCertByIIN(token: String, iin: String) {

    }

    func getUserCertByUID(token: String, uid: String, completion: @escaping (Result<Reply.Mail.ContactWithCert, Error>) -> Void) {

    }

    func getUserInfoByMailAddress(token: String, mailAddress: String, completion: @escaping (Result<Reply.Mail.ContactInfoDTO, Error>) -> Void) {

    }

    func getFileBy(id: String, token: String, completion: @escaping (Result<Reply.Mail.DataWithCertsDTO, Error>) -> Void) {

    }

    func getMailInfoById(token: String, mailId: String, folder: String, completion: @escaping (Result<Reply.Mail.MailInfoDTO, Error>) -> Void) {

    }

    func getLettersList(token: String, parameters: Request.Auth.GetMailListRequestDTO, completion: @escaping (Result<Reply.Mail.MailHeadersResponse, Error>) -> Void) {

    }

    func decodeMailResponse(jsonString: String) -> Reply.Mail.MailHeadersResponse? {
        let jsonData = jsonString.data(using: .utf8)!
        do {
            let mailResponse = try JSONDecoder().decode(Reply.Mail.MailHeadersResponse.self, from: jsonData)
            return mailResponse
        } catch {
            Log.e("Decoding error: \(error.localizedDescription)")
            return nil
        }
    }

    func decodeMailResponse(jsonString: String) -> MailDTO? {
        let jsonData = jsonString.data(using: .utf8)!
        do {
            let mailResponse = try JSONDecoder().decode(MailDTO.self, from: jsonData)
            return mailResponse
        } catch {
            Log.e("Decoding error: \(error.localizedDescription)")
            return nil
        }
    }
}
