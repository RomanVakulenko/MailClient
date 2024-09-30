//
//  NetworkManager+Mail.swift
// 11.07.2024.
//

import Foundation

protocol MailNetworkManaging: AnyObject {
    func getLettersList(token: String, parameters: Request.Auth.GetMailListRequestDTO, completion: @escaping (Result<Reply.Mail.MailHeadersResponse, Error>) -> Void)
    func getMailInfoById(token: String, uidl: String, folder: String, completion: @escaping (Result<Reply.Mail.MailInfoDTO, Error>) -> Void)
    func getFileBy(id: String, token: String, completion: @escaping (Result<Reply.Mail.DataWithCertsDTO, Error>) -> Void)
    func getUserInfoByMailAddress(token: String, mailAddress: String, completion: @escaping (Result<Reply.Mail.ContactInfoDTO, Error>) -> Void)
    func getUserCertByIIN(token: String, iin: String)
    func getUserCertByUID(token: String, uid: String, completion: @escaping (Result<Reply.Mail.ContactWithCert, Error>) -> Void)
    func searchContacts(searchQuery: String, token: String, completion: @escaping (Result<Reply.Mail.ContactSearchListResponseDTO, Error>) -> Void)
    func setMailStatus(parameters: Request.Mail.SetStaturRequestDTO, token: String, completion: @escaping () -> Void)
}

extension NetworkManager: MailNetworkManaging {
    func setMailStatus(parameters: Request.Mail.SetStaturRequestDTO, token: String, completion: @escaping () -> Void) {
        networkService.setMailStatus(parameters: parameters, 
                                     token: token,
                                     completion: completion)
    }
    
    func searchContacts(searchQuery: String, token: String, completion: @escaping (Result<Reply.Mail.ContactSearchListResponseDTO, Error>) -> Void) {
        networkService.searchContacts(searchQuery: searchQuery, 
                                      token: token,
                                      completion: completion)
    }
    
    func getUserCertByIIN(token: String, iin: String) {
        networkService.getUserCertByIIN(token: token, 
                                        iin: iin)
    }
    
    func getUserCertByUID(token: String, uid: String, completion: @escaping (Result<Reply.Mail.ContactWithCert, Error>) -> Void) {
        networkService.getUserCertByUID(token: token, 
                                        uid: uid,
                                        completion: completion)
    }
    
    func getUserInfoByMailAddress(token: String, mailAddress: String, completion: @escaping (Result<Reply.Mail.ContactInfoDTO, Error>) -> Void) {
        networkService.getUserInfoByMailAddress(token: token, 
                                                mailAddress: mailAddress,
                                                completion: completion)
    }

    func getFileBy(id: String, token: String, completion: @escaping (Result<Reply.Mail.DataWithCertsDTO, Error>) -> Void) {
        networkService.getFileBy(id: id, 
                                 token: token,
                                 completion: completion)
    }

    func getMailInfoById(token: String, uidl: String, folder: String, completion: @escaping (Result<Reply.Mail.MailInfoDTO, Error>) -> Void) {
        networkService.getMailInfoById(token: token,
                                       mailId: uidl,
                                       folder: folder,
                                       completion: completion)
    }
    
    func getLettersList(token: String, parameters: Request.Auth.GetMailListRequestDTO, completion: @escaping (Result<Reply.Mail.MailHeadersResponse, Error>) -> Void) {
        networkService.getLettersList(token: token, 
                                      parameters: parameters,
                                      completion: completion)
    }
}
