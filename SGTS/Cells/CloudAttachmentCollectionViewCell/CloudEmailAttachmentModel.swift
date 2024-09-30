//
//  CloudEmailAttachmentModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.04.2024.
//

import UIKit
import DifferenceKit


// MARK: - CloudEmailAttachmentViewModelOutput
protocol CloudEmailAttachmentViewModelOutput: AnyObject {
    func didTapAtCloudAttachment(_ viewModel: CloudEmailAttachmentViewModel)
    func didTapAtXButtonAtCloudAttachment(_ viewModel: CloudEmailAttachmentViewModel)
}

struct CloudEmailAttachmentViewModel {

    enum TapAt {
        case cloudAttachment, xButton
    }

    let id: String
    let filenameWithoutExt: NSAttributedString
    let filenameWithExt: String?
    let backColor: UIColor
    let borderColor: UIColor
    let attachmentIconOfCloud: UIImage?
    let insets: UIEdgeInsets
    let xButton: UIImage?
    let isNewCreatingEmail: Bool?

    weak var output: CloudEmailAttachmentViewModelOutput?

    init(id: String, filenameWithoutExt: NSAttributedString, filenameWithExt: String?, backColor: UIColor, borderColor: UIColor, attachmentIconOfCloud: UIImage?, insets: UIEdgeInsets, output: CloudEmailAttachmentViewModelOutput? = nil, xButton: UIImage? = nil, isNewCreatingEmail: Bool? = false) {
        self.id = id
        self.filenameWithoutExt = filenameWithoutExt
        self.filenameWithExt = filenameWithExt
        self.backColor = backColor
        self.borderColor = borderColor
        self.attachmentIconOfCloud = attachmentIconOfCloud
        self.insets = insets
        self.xButton = xButton
        self.isNewCreatingEmail = isNewCreatingEmail
        self.output = output
    }

    func tapAt(_ sender: TapAt) {
        switch sender {
        case .cloudAttachment:
            output?.didTapAtCloudAttachment(self)
        case .xButton:
            output?.didTapAtXButtonAtCloudAttachment(self)
        }
    }
}

// MARK: - Extensions

extension CloudEmailAttachmentViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: CloudEmailAttachmentViewModel) -> Bool {
        source.filenameWithoutExt == filenameWithoutExt &&
        source.filenameWithExt == filenameWithExt &&
        source.backColor == backColor &&
        source.borderColor == borderColor &&
        source.attachmentIconOfCloud == attachmentIconOfCloud &&
        source.insets == insets &&
        source.xButton == xButton &&
        source.isNewCreatingEmail == isNewCreatingEmail
    }
}
