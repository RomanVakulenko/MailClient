//
//  AttachmentCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import Foundation
import DifferenceKit

protocol AttachmentCellViewModelOutput: AnyObject {
    func didTapAttachmentCell(_ viewModel: AttachmentCellViewModel)
}

struct AttachmentCellViewModel {
    let id: String
    let backColor: UIColor
    let iconOfAttachmentExtension: UIImage

    let fileNameWithExt: NSAttributedString
    let nameAndSurname: NSAttributedString

    let downloadingDate: NSAttributedString
    let downloadingSize: NSAttributedString

    let separatorInsets: UIEdgeInsets
    let insets: UIEdgeInsets

    weak var output: AttachmentCellViewModelOutput?

    init(id: String, backColor: UIColor, iconOfAttachmentExtension: UIImage, fileNameWithExt: NSAttributedString, nameAndSurname: NSAttributedString, downloadingDate: NSAttributedString, downloadingSize: NSAttributedString, separatorInsets: UIEdgeInsets, insets: UIEdgeInsets, output: AttachmentCellViewModelOutput? = nil) {
        self.id = id
        self.backColor = backColor
        self.iconOfAttachmentExtension = iconOfAttachmentExtension
        self.fileNameWithExt = fileNameWithExt
        self.nameAndSurname = nameAndSurname
        self.downloadingDate = downloadingDate
        self.downloadingSize = downloadingSize
        self.separatorInsets = separatorInsets
        self.insets = insets
        self.output = output
    }

    func didTapAttachmentCell() {
        output?.didTapAttachmentCell(self)
    }
}


extension AttachmentCellViewModel: Differentiable {
    var differenceIdentifier: String {
        id
    }

    func isContentEqual(to source: AttachmentCellViewModel) -> Bool {
        source.id == id &&
        source.backColor == backColor &&
        source.iconOfAttachmentExtension == iconOfAttachmentExtension &&
        source.fileNameWithExt == fileNameWithExt &&
        source.nameAndSurname == nameAndSurname &&
        source.downloadingDate == downloadingDate &&
        source.downloadingSize == downloadingSize &&
        source.separatorInsets == separatorInsets &&
        source.insets == insets
    }
}
