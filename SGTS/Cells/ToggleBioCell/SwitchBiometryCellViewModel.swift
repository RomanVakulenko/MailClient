//
//  SwitchBiometryCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.04.2024.
//

import Foundation
import DifferenceKit


protocol SwitchBiometryCellViewModelOutput: AnyObject {
    func didSwitch(_ viewModel: SwitchBiometryCellViewModel, isOn: Bool)
}


struct SwitchBiometryCellViewModel {
    let id: AnyHashable
    let title: NSAttributedString
    var isOn: Bool
    let isActive: Bool
    let switchStateNotificationName: Notification.Name?
    let isActiveKey: String?
    let thumbColorOff: UIColor //circle
    let thumbColorOn: UIColor //circle
    let tintColorBackOff: UIColor //off
    let onTintColorBackOn: UIColor //on
    let insets: UIEdgeInsets    

    weak var output: SwitchBiometryCellViewModelOutput?

    init(id: AnyHashable,
         title: NSAttributedString,
         isOn: Bool = false,
         isActive: Bool = false,
         switchStateNotificationName: Notification.Name?,
         isActiveKey: String?,
         thumbColorOff: UIColor,
         thumbColorOn: UIColor,
         tintColorBackOff: UIColor,
         onTintColorBackOn: UIColor,
         insets: UIEdgeInsets = .zero,
         output: SwitchBiometryCellViewModelOutput? = nil) {
        self.id = id
        self.title = title
        self.isOn = isOn
        self.isActive = isActive
        self.switchStateNotificationName = switchStateNotificationName
        self.isActiveKey = isActiveKey
        self.thumbColorOff = thumbColorOff
        self.thumbColorOn = thumbColorOn
        self.tintColorBackOff = tintColorBackOff
        self.onTintColorBackOn = onTintColorBackOn
        self.insets = insets
        self.output = output
    }

    func didTapAtSwitch(isOn: Bool) {
        output?.didSwitch(self, isOn: isOn)
    }
}


extension SwitchBiometryCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: SwitchBiometryCellViewModel) -> Bool {
        source.title == title &&
        source.isActive == isActive &&
        source.isOn == isOn &&
        source.isActive == isActive &&
        source.switchStateNotificationName == switchStateNotificationName &&
        source.isActiveKey == isActiveKey &&
        source.thumbColorOff == thumbColorOff &&
        source.thumbColorOn == thumbColorOn &&
        source.tintColorBackOff == tintColorBackOff &&
        source.onTintColorBackOn == onTintColorBackOn &&
        source.insets == insets
    }
}
