//
//  Mode.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.04.2024.
//

import Foundation
import UIKit

final class Theme {

    static let shared = Theme()

    var isLight: Bool

    private init() {
        self.isLight = true //TODO later load from UserDefaults (probably)
        NotificationCenter.default.post(
            name: NSNotification.Name.screenThemeWasChanged,
            object: nil)
    }

    ///Change the theme  (Light / Dark) throughout the application.
    func toggleTheme() {
        isLight.toggle()
        NotificationCenter.default.post(
            name: NSNotification.Name.screenThemeWasChanged,
            object: nil)
    }
}

