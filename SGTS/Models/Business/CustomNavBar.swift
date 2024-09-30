//
//  NavBar.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.05.2024.
//

import UIKit


struct CustomNavBar {
    let title: NSAttributedString
    let isLeftBarButtonEnable: Bool
    let isLeftBarButtonCustom: Bool?
    let leftBarButtonCustom: NavBarButton?
    let rightBarButtons: [NavBarButton]?
}

struct NavBarButton {
    let image: UIImage?
    let color: UIColor?


    init(image: UIImage?, color: UIColor? = nil) {
        self.image = image
        self.color = color
    }
}
