//
//  UserAgent.swift
// 02.08.2024.
//

import UIKit

func getUserAgent() -> String {
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "UnknownApp"
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    let device = UIDevice.current.model
    let osVersion = UIDevice.current.systemVersion
    let locale = Locale.current.identifier

    return "\(appName)/\(appVersion) (\(device); iOS \(osVersion); \(locale))"
}
