//
//  FotoCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.04.2024.
//

import Foundation
import DifferenceKit

protocol FotoCellViewModelOutput: AnyObject {
    func didTapAtFoto(_ viewModel: FotoCellViewModel)
    func didTapAtDownloadIcon(_ viewModel: FotoCellViewModel)
    func didTapAtQuattroIcon(_ viewModel: FotoCellViewModel)
}

struct FotoCellViewModel {

    enum TapAt {
        case foto, downloadIcon, quattroIcon
    }

    let id: AnyHashable
    let backColor: UIColor
    let borderColor: UIColor
    let fotoImage: UIImage
    let fileIcon: UIImage
    let fileNameWithExt: NSAttributedString
    let downloadIcon: UIImage
    let quattroIcon: UIImage
    let insets: UIEdgeInsets

    weak var output: FotoCellViewModelOutput?

    init(id: AnyHashable, backColor: UIColor, borderColor: UIColor, fotoImage: UIImage, fileIcon: UIImage, fileName: NSAttributedString, downloadIcon: UIImage, quattroIcon: UIImage, insets: UIEdgeInsets, output: FotoCellViewModelOutput? = nil) {
        self.id = id
        self.backColor = backColor
        self.borderColor = borderColor
        self.fotoImage = fotoImage
        self.fileIcon = fileIcon
        self.fileNameWithExt = fileName
        self.downloadIcon = downloadIcon
        self.quattroIcon = quattroIcon
        self.insets = insets
        self.output = output
    }

    func onTap(_ sender: TapAt) {
        switch sender {
        case .foto:
            output?.didTapAtFoto(self)
        case .downloadIcon:
            output?.didTapAtDownloadIcon(self)
        case .quattroIcon:
            output?.didTapAtQuattroIcon(self)
        }
    }
}


extension FotoCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: FotoCellViewModel) -> Bool {
        source.id == id &&
        source.backColor == backColor &&
        source.borderColor == borderColor &&
        source.fotoImage == fotoImage &&
        source.fileIcon == fileIcon &&
        source.fileNameWithExt == fileNameWithExt &&
        source.downloadIcon == downloadIcon &&
        source.quattroIcon == quattroIcon &&
        source.insets == insets
    }
}
