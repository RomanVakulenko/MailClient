//
//  ContextualActionHelper.swift
// 10.01.2024.
//

import UIKit

public struct ContextualActionHelper {
    public static func createAction(action: @escaping () -> Void, style: UIContextualAction.Style = .normal, title: String? = nil, image: UIImage? = nil, color: UIColor? = nil) -> UIContextualAction {
        let contextualAction = UIContextualAction(style: style, title: title) { (_, _, completion) in
            action()
            completion(true)
        }
        
        if let image = image, #available(iOS 13.0, *) {
            contextualAction.image = image
        }
        
        if let color = color {
            contextualAction.backgroundColor = color
        }
        
        return contextualAction
    }
}
