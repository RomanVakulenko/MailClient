//
//  PinCodeWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import Foundation

protocol PinCodeWorkingLogic {
    
}


final class PinCodeWorker: PinCodeWorkingLogic {
    private let network: NetworkManaging = NetworkManager()
    
    
    
    
    
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
