//
//  UserProfileChangePinCodeWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import Foundation
import Security
import LocalAuthentication

protocol UserProfileChangePinCodeWorkingLogic {
    func requestBiometryPermission(completion: @escaping (Result<Bool, Error>) -> Void)
}


final class UserProfileChangePinCodeWorker: UserProfileChangePinCodeWorkingLogic {

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




//
//    private func errorDescriptor(_ error: Error) -> TransportError {
//        errorCodeConverter(code: error.asAFError?.responseCode)
//    }
//
//    private func errorCodeConverter(code: Int?) -> TransportError {
//        switch code {
//        case 403:
//            return .noPermission
//        case 401:
//            return .unauthorized
//        case 400:
//            return .incorrectInputData
//        default:
//            return .unknown
//        }
//    }
}
