//
//  UICollectionViewCell+Extensions.swift
//  SGTS
//
//  Created by Roman Vakulenko on 21.04.2024.
//

import UIKit

extension UICollectionViewCell {
    class var ReuseId: String {
       "\(String(describing: self))Id"
    }
}
