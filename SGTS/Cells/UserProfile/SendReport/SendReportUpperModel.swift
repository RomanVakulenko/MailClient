//
//  SendReportUpperModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 01.07.2024.
//

import UIKit
import DifferenceKit

enum SendReportUpperModel {

    enum TypeOfField {
        case subject, to, copy
    }

    struct ViewModel {
        let backColor: UIColor

        let subjectLabel: NSAttributedString
        let subjectText: String

        let toLabel: NSAttributedString
        let toEmailAddressesText: String?
        let toRectIcon: UIImage

        let copyLabel: NSAttributedString
        let copyRectIcon: UIImage

        let toCopyTextColor: UIColor

        let separatorColor: UIColor
        let insets: UIEdgeInsets
    }
}


extension SendReportUpperModel.ViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        toEmailAddressesText // 01.07 в ТГ: Что взять в качестве differenceIdentifier для SendReportUpperModel (это все ОТ набБара и ДО ТекстаСообщения)? пока не знаю - будет ли какой-то id отправляемого сообщения - как он будет формироваться?
    }

    func isContentEqual(to source: SendReportUpperModel.ViewModel) -> Bool {
        source.backColor == backColor &&
        source.subjectLabel == subjectLabel &&
        source.subjectText == subjectText &&
        source.toLabel == toLabel &&
        source.toEmailAddressesText == toEmailAddressesText &&
        source.toRectIcon == toRectIcon &&
        source.copyLabel == copyLabel &&
        source.copyRectIcon == copyRectIcon &&
        source.toCopyTextColor == toCopyTextColor &&
        source.separatorColor == separatorColor &&
        source.insets == insets
    }
}
