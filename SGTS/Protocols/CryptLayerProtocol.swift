//
//  CryptLayerProtocol.swift
// 24.07.2024.
//

import Foundation

protocol CryptoLayerProtocol: AnyObject {
    func saveUserBin(container: Data, password: String)
    func hasUserBin() -> Bool
    func checkCerts() -> Bool
    func saveCerts(certSign: Data, certXchg: Data)
    func decryptCode(with sk: String, and encryptedCode: String) -> String
    func saveUserCerts(certSign: Data, certXchg: Data, cn: String)
    func decryptFile(sender: Sender, meta: FileMeta, recipient: Recipient, tempPath: String, realPath: String) -> Bool
    func decryptData(sourceData: Data, skey: String, senderDN: String, hash: String, sign: String) -> Data?
    func encryptFile(sender: inout Sender, recipients: inout [Recipient], realPath: URL?, tempPath: URL?, sign: inout String, hash: inout String) -> Bool
}
