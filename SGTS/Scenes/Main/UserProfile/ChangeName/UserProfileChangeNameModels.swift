//
//  UserProfileChangeNameModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import DifferenceKit
import UIKit

protocol UserProfileChangeNameViewModelOutput: AnyObject {
    func onChangeText(_ viewModel: UserProfileChangeNameViewModel, currentText: String)
}

struct UserProfileChangeNameViewModel {
    let grayViewBackColor: UIColor
    let backColorOfChangeNameView: UIColor

    let titleOfChangeNameView: NSAttributedString

    let userNameSubtitle: NSAttributedString
    let userFullName: NSAttributedString
    let senderTitleAtBorder: NSAttributedString
    let borderTitleBackColor: UIColor
    let borderColor: UIColor
    let senderName: String?

    let cancelTitle: NSAttributedString
    let saveTitle: NSAttributedString


    weak var output: UserProfileChangeNameViewModelOutput?

    func onChangeText(currentText: String?) {
        output?.onChangeText(self, currentText: currentText ?? "")
    }

}
