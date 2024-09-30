//
//  EmailCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import Foundation
import DifferenceKit

protocol EmailCellViewModelOutput: AnyObject {
    func didLongPressAt(_ viewModel: EmailCellViewModel)
    func didTapAtOneEmail(_ viewModel: EmailCellViewModel)
}

struct EmailCellViewModel {
    let id: String //было AnyHashable
    let backColor: UIColor
    let avatarImage: UIImage
    let emailSender: NSAttributedString
    let emailTitle: NSAttributedString

    let allIconViewsForOneCell: [UIImageView]?
    let emailText: NSAttributedString
    let emailDate: NSAttributedString

    let isNewEmailIconDisplaying: Bool
    let newEmailCloudBackColor: UIColor?
    let newEmailCloudTitle: NSAttributedString?
    let isPersonalToUserIconDisplaying: Bool?
    let isEmportantEmailIndicatorDisplaying: Bool?
    let isExternalEmailIconDisplaying: Bool?
    let isAttachmentIconDisplaying: Bool?

    let insets: UIEdgeInsets
    let separatorInset: UIEdgeInsets
    let items: [AnyDifferentiable]
    let widths: [CGFloat]

    weak var output: EmailCellViewModelOutput?

    init(id: String, backColor: UIColor, avatarImage: UIImage, emailSender: NSAttributedString, emailTitle: NSAttributedString, allIconViewsForOneCell: [UIImageView]?, emailText: NSAttributedString, emailDate: NSAttributedString, isNewEmailIconDisplaying: Bool, newEmailCloudBackColor: UIColor, newEmailCloudTitle: NSAttributedString?, isPersonalToUserIconDisplaying: Bool, isEmportantEmailIndicatorDisplaying: Bool, isExternalEmailIconDisplaying: Bool, isAttachmentIconDisplaying: Bool, insets: UIEdgeInsets, separatorInset: UIEdgeInsets, items: [AnyDifferentiable], widths: [CGFloat], output: EmailCellViewModelOutput? = nil) {
        self.id = id
        self.backColor = backColor
        self.avatarImage = avatarImage
        self.emailSender = emailSender
        self.emailTitle = emailTitle
        self.allIconViewsForOneCell = allIconViewsForOneCell
        self.emailText = emailText
        self.emailDate = emailDate
        self.isNewEmailIconDisplaying = isNewEmailIconDisplaying
        self.newEmailCloudBackColor = newEmailCloudBackColor
        self.newEmailCloudTitle = newEmailCloudTitle
        self.isPersonalToUserIconDisplaying = isPersonalToUserIconDisplaying
        self.isEmportantEmailIndicatorDisplaying = isEmportantEmailIndicatorDisplaying
        self.isExternalEmailIconDisplaying = isExternalEmailIconDisplaying
        self.isAttachmentIconDisplaying = isAttachmentIconDisplaying
        self.insets = insets
        self.separatorInset = separatorInset
        self.items = items
        self.widths = widths
        self.output = output
    }


    func onLongTap() {
        output?.didLongPressAt(self)
    }

    func didTapAtEmail() {
        output?.didTapAtOneEmail(self)
    }
}


extension EmailCellViewModel: Differentiable {
    var differenceIdentifier: String {
        id
    }

    func isContentEqual(to source: EmailCellViewModel) -> Bool {
        source.id == id &&
        source.backColor == backColor &&
        source.avatarImage == avatarImage &&
        source.emailSender == emailSender &&
        source.emailTitle == emailTitle &&
        source.allIconViewsForOneCell == allIconViewsForOneCell &&
        source.emailText == emailText &&
        source.emailDate == emailDate &&
        source.isNewEmailIconDisplaying == isNewEmailIconDisplaying &&
        source.newEmailCloudBackColor == newEmailCloudBackColor &&
        source.isNewEmailIconDisplaying == isNewEmailIconDisplaying &&
        source.isPersonalToUserIconDisplaying == isPersonalToUserIconDisplaying &&
        source.isEmportantEmailIndicatorDisplaying == isEmportantEmailIndicatorDisplaying &&
        source.isExternalEmailIconDisplaying == isExternalEmailIconDisplaying &&
        source.isAttachmentIconDisplaying == isAttachmentIconDisplaying &&
        source.separatorInset == separatorInset &&
        source.insets == insets
    }
}
