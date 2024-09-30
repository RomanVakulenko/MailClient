//
//  NextStepButtonCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation
import DifferenceKit


protocol NextStepButtonViewModelOutput: AnyObject {
    func didTapAt(_ viewModel: NextStepButtonCellViewModel)
}


struct NextStepButtonCellViewModel {
    let id: AnyHashable
    let activeTitle: NSAttributedString
    let nonActiveTitle: NSAttributedString
    let activeBackColor: UIColor
    let nonActiveBackColor: UIColor
    let insets: UIEdgeInsets
    var isActive: Bool
    let switchStateNotificationName: Notification.Name?
    let isActiveKey: String?
    let borderWidth: CGFloat?
    let borderColor: UIColor?

    weak var output: NextStepButtonViewModelOutput?

    init(id: AnyHashable, activeTitle: NSAttributedString, nonActiveTitle: NSAttributedString, activeBackColor: UIColor, nonActiveBackColor: UIColor, insets: UIEdgeInsets, isActive: Bool, switchStateNotificationName: Notification.Name?, isActiveKey: String?,  borderWidth: CGFloat? = nil, borderColor: UIColor? = nil, output: NextStepButtonViewModelOutput? = nil) {
        self.id = id
        self.activeTitle = activeTitle
        self.nonActiveTitle = nonActiveTitle
        self.activeBackColor = activeBackColor
        self.nonActiveBackColor = nonActiveBackColor
        self.insets = insets
        self.isActive = isActive
        self.switchStateNotificationName = switchStateNotificationName
        self.isActiveKey = isActiveKey
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.output = output
    }

    func onTap() {
        output?.didTapAt(self)
    }
}


extension NextStepButtonCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: NextStepButtonCellViewModel) -> Bool {
        return activeTitle == source.activeTitle &&
        nonActiveTitle == source.nonActiveTitle &&
        activeBackColor == source.activeBackColor &&
        nonActiveBackColor == source.nonActiveBackColor &&
        insets == source.insets &&
        isActive == source.isActive &&
        switchStateNotificationName == source.switchStateNotificationName &&
        isActiveKey == source.isActiveKey &&
        borderWidth == source.borderWidth &&
        borderColor == source.borderColor
    }
}



