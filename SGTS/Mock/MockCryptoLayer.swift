//
//  MockCryptoLayer.swift
// 24.07.2024.
//

import Foundation

class MockCryptoLayer: CryptoLayerProtocol {

    static let shared: CryptoLayerProtocol = MockCryptoLayer()
    private init() {}

    func saveUserBin(container: Data, password: String) {
        print("Mock: saveUserBin called with container: \(container), password: \(password)")
    }

    func hasUserBin() -> Bool {
        print("Mock: hasUserBin called")
        return true
    }

    func checkCerts() -> Bool {
        print("Mock: checkCerts called")
        return true
    }

    func saveCerts(certSign: Data, certXchg: Data) {
        print("Mock: saveCerts called with certSign: \(certSign), certXchg: \(certXchg)")
    }

    func decryptCode(with sk: String, and encryptedCode: String) -> String {
        print("Mock: decryptCode called with sk: \(sk), encryptedCode: \(encryptedCode)")
        return "DecryptedCode"
    }

    func saveUserCerts(certSign: Data, certXchg: Data, cn: String) {
        print("Mock: saveUserCerts called with certSign: \(certSign), certXchg: \(certXchg), cn: \(cn)")
    }

    func decryptFile(sender: Sender, meta: FileMeta, recipient: Recipient, tempPath: String, realPath: String) -> Bool {
        print("Mock: decryptFile called with sender: \(sender), meta: \(meta), recipient: \(recipient), tempPath: \(tempPath), realPath: \(realPath)")
        return true
    }
    
    func decryptData(sourceData: Data, skey: String, senderDN: String, hash: String, sign: String) -> Data? {
        print("Mock: decryptData called with sourceData: \(sourceData), skey: \(skey), senderDN: \(senderDN), hash: \(hash), sign: \(sign)")
        return sourceData
    }
    
    func encryptFile(sender: inout Sender, recipients: inout [Recipient], realPath: URL?, tempPath: URL?, sign: inout String, hash: inout String) -> Bool {
        print("Mock: encryptFile called with sender: \(sender), recipients: \(recipients), realPath: \(String(describing: realPath)), tempPath: \(String(describing: tempPath)), sign: \(sign), hash: \(hash)")
        sign = "MockSign"
        hash = "MockHash"
        return true
    }
}
