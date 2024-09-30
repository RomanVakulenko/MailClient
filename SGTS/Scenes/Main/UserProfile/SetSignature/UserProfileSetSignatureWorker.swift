//
//  UserProfileSetSignatureWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import Foundation
import Security
import LocalAuthentication

protocol UserProfileSetSignatureWorkingLogic {
    func requestBiometryPermission(completion: @escaping (Result<Bool, Error>) -> Void)
}


final class UserProfileSetSignatureWorker: UserProfileSetSignatureWorkingLogic {

    // MARK: - Private properties

    private let context = LAContext()

    // MARK: - Public methods

    func requestBiometryPermission(completion: @escaping (Result<Bool, Error>) -> Void) {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "needsToIdentify"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        if KeychainService.set(true, forKey: "id приложения" + "isFaceIdEnable"),
                           KeychainService.set(true, forKey: "id приложения" + "storedPinCode") {
                            completion(.success(true))
                        }
                    } else {
                        _ = KeychainService.set(false, forKey: "id приложения" + "isFaceIdEnable")
                        _ = KeychainService.set(false, forKey: "id приложения" + "storedPinCode")
                        if let authenticationError = authenticationError {
                            completion(.failure(authenticationError))
                        } else if let error = error {
                            completion(.failure(error))
                        }
                    }
                }
            }
        } else {
            if let error = error {
                completion(.failure(error))
            }
        }
    }

}
