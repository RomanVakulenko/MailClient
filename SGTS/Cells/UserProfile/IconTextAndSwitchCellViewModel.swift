//
//  IconTextAndSwitchCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 18.06.2024.
//

import UIKit
import DifferenceKit


protocol IconTextAndSwitchCellViewModelOutput: AnyObject {
    //    func didSwitch(_ viewModel: IconTextAndSwitchCellViewModel, isOn: Bool)
        func didSwitch(_ viewModel: IconTextAndSwitchCellViewModel)
}


struct IconTextAndSwitchCellViewModel {
    let id: AnyHashable
    let cellBackColor: UIColor
    let icon: UIImage
    let title: NSAttributedString
    var isOn: Bool
    let thumbColorOff: UIColor //circle
    let thumbColorOn: UIColor //circle
    let tintColorBackOff: UIColor //off
    let onTintColorBackOn: UIColor //on
    let insets: UIEdgeInsets

    weak var output: IconTextAndSwitchCellViewModelOutput?

    init(id: AnyHashable, cellBackColor: UIColor, icon: UIImage, title: NSAttributedString, isOn: Bool, thumbColorOff: UIColor, thumbColorOn: UIColor, tintColorBackOff: UIColor, onTintColorBackOn: UIColor, insets: UIEdgeInsets, output: IconTextAndSwitchCellViewModelOutput? = nil) {
        self.id = id
        self.cellBackColor = cellBackColor
        self.icon = icon
        self.title = title
        self.isOn = isOn
        self.thumbColorOff = thumbColorOff
        self.thumbColorOn = thumbColorOn
        self.tintColorBackOff = tintColorBackOff
        self.onTintColorBackOn = onTintColorBackOn
        self.insets = insets
        self.output = output
    }
    
    //func didTapAtSwitch(isOn: Bool) {
    //        output?.didSwitch(self, isOn: isOn)
    //    }
    func didTapAtSwitch() {
        output?.didSwitch(self)
        
    }
}


extension IconTextAndSwitchCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: IconTextAndSwitchCellViewModel) -> Bool {
        source.cellBackColor == cellBackColor &&
        source.icon == icon &&
        source.title == title &&
        source.isOn == isOn &&
        source.thumbColorOff == thumbColorOff &&
        source.thumbColorOn == thumbColorOn &&
        source.tintColorBackOff == tintColorBackOff &&
        source.onTintColorBackOn == onTintColorBackOn &&
        source.insets == insets
    }
}
