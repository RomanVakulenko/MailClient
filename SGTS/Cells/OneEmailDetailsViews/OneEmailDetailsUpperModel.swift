//
//  OneEmailDetailsUpperModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 23.04.2024.
//


import UIKit
import DifferenceKit

enum OneEmailDetailsUpperModel {

    struct ViewModel {
        let id: AnyHashable
        let backColor: UIColor
        let oneEmailTitle: NSAttributedString
        let subTitleReceived: NSAttributedString
        let dateTimeSubTitle: NSAttributedString
        let hasAttachments: Bool
        let attachmentIcon: UIImage

        let mainImage: UIImage

        let fromTitleAndAdress: NSAttributedString
        let toTitleAndAdresses: NSAttributedString
        let neededLinesForAllAdresses: Int

        let didSendTitle: NSAttributedString
        let dateTimeDidSend: NSAttributedString
        let didReceiveTitle: NSAttributedString
        let dateTimeDidReceive: NSAttributedString
        let separatorColor: UIColor
        let insets: UIEdgeInsets


        init(id: AnyHashable, backColor: UIColor, oneEmailTitle: NSAttributedString, subTitleReceived: NSAttributedString, dateTimeSubTitle: NSAttributedString, hasAttachments: Bool, attachmentIcon: UIImage, mainImage: UIImage, fromTitleAndAdress: NSAttributedString, toTitleAndAdresses: NSAttributedString, neededLinesForAllAdresses: Int, didSendTitle: NSAttributedString, dateTimeDidSend: NSAttributedString, didReceiveTitle: NSAttributedString, dateTimeDidReceive: NSAttributedString, separatorColor: UIColor, insets: UIEdgeInsets) {
            self.id = id
            self.backColor = backColor
            self.oneEmailTitle = oneEmailTitle
            self.subTitleReceived = subTitleReceived
            self.dateTimeSubTitle = dateTimeSubTitle
            self.hasAttachments = hasAttachments
            self.attachmentIcon = attachmentIcon
            self.mainImage = mainImage
            self.fromTitleAndAdress = fromTitleAndAdress
            self.toTitleAndAdresses = toTitleAndAdresses
            self.neededLinesForAllAdresses = neededLinesForAllAdresses
            self.didSendTitle = didSendTitle
            self.dateTimeDidSend = dateTimeDidSend
            self.didReceiveTitle = didReceiveTitle
            self.dateTimeDidReceive = dateTimeDidReceive
            self.separatorColor = separatorColor
            self.insets = insets
        }
    }

    

}

extension OneEmailDetailsUpperModel.ViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: OneEmailDetailsUpperModel.ViewModel) -> Bool {
        source.backColor == backColor &&
        source.oneEmailTitle == oneEmailTitle &&
        source.subTitleReceived == subTitleReceived &&
        source.dateTimeSubTitle == dateTimeSubTitle &&
        source.hasAttachments == hasAttachments &&
        source.attachmentIcon == attachmentIcon &&
        source.mainImage == mainImage &&
        source.fromTitleAndAdress == fromTitleAndAdress &&
        source.toTitleAndAdresses == toTitleAndAdresses &&
        source.neededLinesForAllAdresses == neededLinesForAllAdresses &&
        source.didSendTitle == didSendTitle &&
        source.dateTimeDidSend == dateTimeDidSend &&
        source.didReceiveTitle == didReceiveTitle &&
        source.dateTimeDidReceive == dateTimeDidReceive &&
        source.separatorColor == separatorColor &&
        source.insets == insets
    }
}

