//
//  UIHelper.swift
// 01.04.2024.
//

import UIKit

enum UIHelper {

    enum Attributed {
        //Both
        static let none: [NSAttributedString.Key: Any] = [.font: Font.none, .foregroundColor: UIColor.clear]

        static let whiteRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.white]
        static let blueRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.blue]
        static let dustWhiteDRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.dustWhiteD]

        static let almostWhiteLRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.almostWhiteL]
        static let blackMiddleLRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.blackMiddleL]

        static let whiteStrongLRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.whiteStrong]//backFwrL
        static let almostBlackDRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.almostBlackD] //backFwrD

        static let blackMiddleLRobotoMedium14Underlined: [NSAttributedString.Key: Any] = [
            .font: Font.RobotoMedium14,
            .foregroundColor: Color.blackMiddleL,
            .underlineStyle: NSUnderlineStyle.single.rawValue]

        static let whiteStrongRobotoMedium14Underlined: [NSAttributedString.Key: Any] = [
            .font: Font.RobotoMedium14,
            .foregroundColor: Color.whiteStrong,
            .underlineStyle: NSUnderlineStyle.single.rawValue]

        static let grayAlpha06RobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.grayAlpha06]
        static let grayRegularDRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.grayRegularD]
        static let whiteDarkDRobotoMedium14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.whiteDarkD]


        static let blackMiddleLRobotoMedium18: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium18, .foregroundColor: Color.blackMiddleL]
        static let whiteRobotoMedium18: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium18, .foregroundColor: Color.white]

        static let blackMiddleLRobotoMedium17: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium17, .foregroundColor: Color.blackMiddleL]
        static let whiteStrongDRobotoMedium17: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium17, .foregroundColor: Color.whiteStrong]

        static let whiteRobotoBold11: [NSAttributedString.Key: Any] = [.font: Font.RobotoBold11, .foregroundColor: Color.white]//newEmailCloudTitle
        static let whiteStrongRobotoBold11: [NSAttributedString.Key: Any] = [.font: Font.RobotoBold11, .foregroundColor: Color.whiteStrong]

        static let whiteRobotoBold18: [NSAttributedString.Key: Any] = [.font: Font.RobotoBold18, .foregroundColor: Color.white]
        static let blackMiddleRobotoBold18: [NSAttributedString.Key: Any] = [.font: Font.RobotoBold18, .foregroundColor: Color.blackMiddleL]

        static let blackStrongLRobotoMedium18: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium18, .foregroundColor: Color.blackStrongL] //MailStartTitle, EmailPickingTitleL
        static let whiteStrongRobotoMedium18: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium18, .foregroundColor: Color.whiteStrong]
        static let whiteRobotoMedium20: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium20, .foregroundColor: Color.white] //ImageFullScreenTitle
                static let blackMiddleLRobotoMedium20: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium20, .foregroundColor: Color.blackMiddleL] //ImageFullScreenTitle

        static let blackMiddleLRobotoSemibold17: [NSAttributedString.Key: Any] = [.font: Font.RobotoSemiBold17, .foregroundColor: Color.blackMiddleL]
        static let whiteStrongRobotoSemibold17: [NSAttributedString.Key: Any] = [.font: Font.RobotoSemiBold17, .foregroundColor: Color.whiteStrong]


        static let grayLRobotoRegular12: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular12, .foregroundColor: Color.grayL]
        static let blueRobotoRegular12: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular12, .foregroundColor: Color.blue]
        static let whiteHalfRobotoRegular12: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular12, .foregroundColor: Color.whiteHalf]

        static let grayAlpha06RobotoRegular12: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular12, .foregroundColor: Color.grayAlpha06]//swipeInstructionTextLblL
        static let grayRegularDRobotoRegular12: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular12, .foregroundColor: Color.grayRegularD]//swipeInstructionTextLblD

        static let grayAlpha06RobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.grayAlpha06]//oneAttachment.nameAndSurname


        static var paragraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = 0
            paragraphStyle.maximumLineHeight = 0
            return  paragraphStyle
        }()

        static let grayAlpha06RobotoRegular14WithparagraphStyle: [NSAttributedString.Key: Any] = [
            .font: Font.RobotoRegular14,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: Color.grayAlpha06]

        static let whiteStrongRobotoRegular14WithparagraphStyle: [NSAttributedString.Key: Any] = [
            .font: Font.RobotoRegular14,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: Color.whiteStrong]

        static let whiteDarkDRobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.whiteDarkD]

//        static let grayAlpha06UnderlinedRobotoRegular14: [NSAttributedString.Key: Any] = [
//            .font: Font.RobotoRegular14,
//            .foregroundColor: Color.grayAlpha06,
//            .underlineStyle: NSUnderlineStyle.single.rawValue]
//
//        static let whiteDarkDUnderlinedRobotoRegular14: [NSAttributedString.Key: Any] = [
//            .font: Font.RobotoRegular14,
//            .foregroundColor: Color.whiteDarkD,
//            .underlineStyle: NSUnderlineStyle.single.rawValue]
        static let blueUnderlinedRobotoRegular12: [NSAttributedString.Key: Any] = [
            .font: Font.RobotoRegular12,
            .foregroundColor: Color.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue]

        static let blueUnderlinedRobotoRegular14: [NSAttributedString.Key: Any] = [
            .font: Font.RobotoRegular14,
            .foregroundColor: Color.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        
        static let blueUnderlinedRobotoRegular16: [NSAttributedString.Key: Any] = [
            .font: Font.RobotoRegular16,
            .foregroundColor: Color.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue]

        static let blackStrongLRobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.blackStrongL]
        static let whiteStrongRobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.whiteStrong]

        static let blueRobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.blue]

        static let grayLRobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.grayL]

        static let grayRegularDRobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.grayRegularD] //oneAttachment.nameAndSurname

        static let blackMiddleLRobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.blackMiddleL] //ImageFullScreenTitleMenuLbl

        static let redRobotoRegular14: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular14, .foregroundColor: Color.red]


        static let blackMiddleLRobotoRegular16: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular16, .foregroundColor: Color.blackMiddleL]

        static let grayAlpha06RobotoRegular16: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular16, .foregroundColor: Color.grayAlpha06]
        
        static let whiteDarkDRobotoRegular16: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular16, .foregroundColor: Color.whiteDarkD]

        static let grayLRobotoRegular16: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular16, .foregroundColor: Color.grayL]
        static let grayRegularD2RobotoRegular16: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular16, .foregroundColor: Color.grayRegularD2]
        static let whiteStrongDRobotoRegular16: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular16, .foregroundColor: Color.whiteStrong]

        static let grayRegularDRobotoRegular16: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular16, .foregroundColor: Color.grayRegularD]

        static let blackStrongLRobotoRegular16: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular16, .foregroundColor: Color.blackStrongL]
        static let blackStrongLRobotoRegular18: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular18, .foregroundColor: Color.blackStrongL]

        static let blackMiddleLRobotoRegular18: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular18, .foregroundColor: Color.blackMiddleL]
        static let whiteStrongDRobotoRegular18: [NSAttributedString.Key: Any] = [.font: Font.RobotoRegular18, .foregroundColor: Color.whiteStrong]

        static let blackMiddleLRobotoSemibold20: [NSAttributedString.Key: Any] = [.font: Font.RobotoSemiBold20, .foregroundColor: Color.blackMiddleL] //oneEmailTitleL
        static let whiteStrongRobotoSemibold20: [NSAttributedString.Key: Any] = [.font: Font.RobotoSemiBold20, .foregroundColor: Color.whiteStrong] //oneEmailTitleD

        static let grayAlpha06LRobotoSemiBold14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.grayAlpha06] //от, кому
        static let whiteDarkDRobotoSemiBold14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.whiteDarkD] //от, кому

        static let blackMiddleLRobotoSemiBold14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.blackMiddleL] //от, кому
        static let whiteStrongRobotoSemiBold14: [NSAttributedString.Key: Any] = [.font: Font.RobotoMedium14, .foregroundColor: Color.whiteStrong] //от, кому
    }



    enum Color {
        //Both
        static let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)//lblText, btnText, thumbTintColorOFFL
        static let whiteHalf = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)//lblText, btnText, thumbTintColorOFFL
        static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let blue = UIColor(red: 0.144, green: 0.569, blue: 0.887, alpha: 1) //thumbTintColorON_Both, cloudNewEmailBackView_Both
        static let darkBlue = UIColor(red: 0.144, green: 0.569, blue: 0.887, alpha: 0.5) //switchONBack_Both, borderReplyToAll
        static let whiteStrong = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1) //enterPin, digits, lbl_aferQR,***, backForCloud, thumbTintColorON, emailSenderD, cloudNewEmailTitle, oneEmailTitleD, oneEmailAttachedFileD, oneEmailTextcellTable, forwardBtnBackL,newEmailCreate_toEmailAdressD, searchBarText
        static let red = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 1) //cancelButton

        //LightMode
        static let shadowForMenuAtThreeDotsL = UIColor(red: 0.038, green: 0.097, blue: 0.142, alpha: 0.15)
        static let someGray = UIColor(red: 0.361, green: 0.365, blue: 0.369, alpha: 1)//ImageFullScreenBackNavBar
        static let grayTransparent = UIColor(red: 0.361, green: 0.365, blue: 0.369, alpha: 1)//ImageFullScreenBackNavBar
        static let blueLightL = UIColor(red: 0.33, green: 0.64, blue: 0.93, alpha: 1)
        static let blackMiddleL = UIColor(red: 0.125, green: 0.188, blue: 0.235, alpha: 1) //enterPin,digits,lbl_afterQR, ****, toggleTitle, emailSenderL, emailTitleL, oneEmailTitleL, oneEmailAttachedFileL, newEmailCreate_toEmailAdressL, checkBoxTitle, movePickedEmailsMoveToTitle, searchBarText
        static let blackStrongL = UIColor(red: 0.039, green: 0.041, blue: 0.042, alpha: 1) //logInTitle, MailStartTitle, oneEmailTextcellTableL, EmailPickingTitleL
        static let grayLightL = UIColor(red: 0.863, green: 0.863, blue: 0.863, alpha: 1) //circlePin,rectBorder, cloudBorder, emailCellBackColorL,borderCloudAttachmentL
        static let grayAlpha06 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)//subLbl_afterQR, fotoCellTitleUnderFoto, swipeInstructionTextL, subTitleReceivedL, from/to/copy/themeTitlesAt newEmailCreate_themeText, backNavBarBtn, cloudText, emailText, sandwichL, cloudAttachmentTitleL
        static let grayL = UIColor(red: 0.6, green: 0.686, blue: 0.749, alpha: 1)//rectTitle, placeholderText, switchOFFBack, emailDate, searchNavBarIcon, searchBarPlaceholder, oneAttachment.downloadingDate, tabBarItemTitle
        static let lightBlueL = UIColor(red: 0.144, green: 0.569, blue: 0.887, alpha: 0.3) //inactiveBtn
        static let almostWhiteL = UIColor(red: 0.99, green: 1.00, blue: 1.00, alpha: 1) //inactiveBtnTitle
        static let almostWhiteL2 = UIColor(red: 0.957, green: 0.988, blue: 1, alpha: 1)//newEmailCellBackColorL

        //DarkMode
        static let shadowD = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        static let darkBackD = UIColor(red: 0.138, green: 0.138, blue: 0.138, alpha: 1)
        static let grayD = UIColor(red: 0.286, green: 0.271, blue: 0.31, alpha: 1)
        static let grayMiddleD = UIColor(red: 0.538, green: 0.538, blue: 0.538, alpha: 1)
        static let blackLightD = UIColor(red: 0.079, green: 0.079, blue: 0.079, alpha: 1)//backgroundD, emailCellBackColorD, MovePickedEmailsToBackground
        static let almostBlackD = UIColor(red: 0.138, green: 0.138, blue: 0.138, alpha: 1)//backForCloud,forwardBtnBackD, extendedMenuMoveToColor
        static let almostBlackD2 = UIColor(red: 0.082, green: 0.118, blue: 0.145, alpha: 1) //newEmailCellBackColorD
        static let almostBlackD3 = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)//backCloudAttachment
        static let grayStrongD = UIColor(red: 0.188, green: 0.187, blue: 0.187, alpha: 1)//circlePin, rectBorder, cloudBorder, switchOff, borderCloudAttachmentD, switchOFFBack
        static let whiteDarkD = UIColor(red: 0.742, green: 0.742, blue: 0.742, alpha: 1)//subLbl_afterQR, cloudText, emailTitleD, subTitleReceivedD, from/to/copy/themeTitlesAt newEmailCreate, fotoCellTitleUnderFoto
        static let grayRegularD = UIColor(red: 0.475, green: 0.475, blue: 0.475, alpha: 1)//rectangleLbl, sandwichD backNavBarBtn, passwordPlaceholder, thumbTintColorOFF, toggleTitle, emailText, emailDate,cloudAttachmentTitleD, swipeInstructionTextD, switchThumbCircleOFF, searchNavBarIcon
        static let grayRegularD2 = UIColor(red: 0.475, green: 0.475, blue: 0.475, alpha: 0.5) //searchBarPlaceholder
        static let dustBlueD = UIColor(red: 0.10, green: 0.23, blue: 0.32, alpha: 1)//inactiveBtn
        static let dustWhiteD = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)//inactiveBtnTitle
        static let blackAlpha06D =  UIColor(red: 0.039, green: 0.039, blue: 0.039, alpha: 0.6) //backChangeNameScreen
    }
    

    enum Font {
        static let none = UIFont.systemFont(ofSize: 1, weight: .ultraLight)

        static let RobotoMedium14 = UIFont(name: "Roboto-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium) //emailTitle
        static let RobotoMedium17 = UIFont(name: "Roboto-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium) //AttachmentNameAndExt
        static let RobotoMedium18 = UIFont(name: "Roboto-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium) //MailStartTitle
        static let RobotoMedium20 = UIFont(name: "Roboto-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium) //ImageFullScreenTitle

        static let RobotoRegular12 = UIFont(name: "Roboto-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        static let RobotoRegular14 = UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        static let RobotoRegular16 = UIFont(name: "Roboto-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        static let RobotoRegular18 = UIFont(name: "Roboto-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .regular)

        static let RobotoSemiBold17 = UIFont(name: "Roboto-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold) //emailSender

        static let RobotoBold18 = UIFont(name: "Roboto-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        static let RobotoBold11 = UIFont(name: "Roboto-Bold", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .bold)

        static let RobotoSemiBold20 = UIFont(name: "Roboto-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold) //oneEmailTitle

    }


    enum Image {
        static let secondLogo85x56 = UIImage(named: "secondLogo85x56") ?? UIImage()
        static let initialLogoBlue = UIImage(named: "InitialLogoBlue") ?? UIImage()
        static let initialLogoWhite = UIImage(named: "InitialLogoWhite") ?? UIImage()
        static let logInRegistrQRSmall = UIImage(named: "qrSmall") ?? UIImage()

        static let pinCodeCircleL = UIImage(named: "circleL") ?? UIImage()
        static let pinCodeCircleD = UIImage(named: "circleD") ?? UIImage()
        static let pinCodeFaceIdIcon = UIImage(named: "face") ?? UIImage()

        //LightMode
        static let pinCodeSignOne = UIImage(named: "Number1") ?? UIImage()
        static let pinCodeSignTwo = UIImage(named: "Number2") ?? UIImage()
        static let pinCodeSignThree = UIImage(named: "Number3") ?? UIImage()
        static let pinCodeSignFour = UIImage(named: "Number4") ?? UIImage()
        static let pinCodeSignFive = UIImage(named: "Number5") ?? UIImage()
        static let pinCodeSignSix = UIImage(named: "Number6") ?? UIImage()
        static let pinCodeSignSeven = UIImage(named: "Number7") ?? UIImage()
        static let pinCodeSignEight = UIImage(named: "Number8") ?? UIImage()
        static let pinCodeSignNine = UIImage(named: "Number9") ?? UIImage()
        static let pinCodeSignZero = UIImage(named: "Number0") ?? UIImage()
        static let pinCodeBackSpaceIcon = UIImage(named: "Delete") ?? UIImage()
        //DarkMode
        static let pinCodeSignOneD = UIImage(named: "NumberD1") ?? UIImage()
        static let pinCodeSignTwoD = UIImage(named: "NumberD2") ?? UIImage()
        static let pinCodeSignThreeD = UIImage(named: "NumberD3") ?? UIImage()
        static let pinCodeSignFourD = UIImage(named: "NumberD4") ?? UIImage()
        static let pinCodeSignFiveD = UIImage(named: "NumberD5") ?? UIImage()
        static let pinCodeSignSixD = UIImage(named: "NumberD6") ?? UIImage()
        static let pinCodeSignSevenD = UIImage(named: "NumberD7") ?? UIImage()
        static let pinCodeSignEightD = UIImage(named: "NumberD8") ?? UIImage()
        static let pinCodeSignNineD = UIImage(named: "NumberD9") ?? UIImage()
        static let pinCodeSignZeroD = UIImage(named: "NumberD0") ?? UIImage()
        static let pinCodeBackSpaceIconD = UIImage(named: "DeleteD") ?? UIImage()

        static let xButton14pxL = UIImage(named: "xBtnL") ?? UIImage()
        static let xButton14pxD = UIImage(named: "xBtnD") ?? UIImage()

        static let backArrow16pxL = UIImage(named: "backArrowL16px") ?? UIImage()
        static let backArrow16pxD = UIImage(named: "backArrowD16px") ?? UIImage()
        static let backArrowWhite16px = UIImage(named: "arrowBackWhite16px") ?? UIImage()

        static let secretKeySelectRightBarButtonQRL = UIImage(named: "QRBarBtnL") ?? UIImage()
        static let secretKeySelectRightBarButtonQRD = UIImage(named: "QRBarBtnD") ?? UIImage()

        static let emailUserIcon = UIImage(named: "emailUserIcon") ?? UIImage()
        static let emailImportantIcon = UIImage(named: "emailImportantIcon") ?? UIImage()
        static let emailExternalIcon = UIImage(named: "emailIcon") ?? UIImage()
        static let emailAttachmentIcon = UIImage(named: "emailAttachmentIcon") ?? UIImage()

        static let emailSandwichL = UIImage(named: "emailSandwichL") ?? UIImage()
        static let emailSandwichD = UIImage(named: "emailSandwichD") ?? UIImage()

        static let searchIcon20L = UIImage(named: "searchIcon20L") ?? UIImage()
        static let searchIcon20D = UIImage(named: "searchIcon20D") ?? UIImage()

        static let addNavBarIconL = UIImage(named: "addNavBarIconL") ?? UIImage()
        static let addNavBarIconD = UIImage(named: "addNavBarIconD") ?? UIImage()

        static let archiveNavBarIcon20x20L = UIImage(named: "archiveNavBarIcon20x20L") ?? UIImage()
        static let archiveNavBarIcon20x20D = UIImage(named: "archiveNavBarIcon20x20D") ?? UIImage()
        static let trashNavBarIcon16x22L = UIImage(named: "trashNavBarIcon16x22L") ?? UIImage()
        static let trashNavBarIcon16x22D = UIImage(named: "trashNavBarIcon16x22D") ?? UIImage()
        static let unreadNavBarIcon20x16L = UIImage(named: "unreadNavBarIcon20x16L") ?? UIImage()
        static let unreadNavBarIcon20x16D = UIImage(named: "unreadNavBarIcon20x16D") ?? UIImage()

        static let emailCloudFileIconAudio = UIImage(named: "fileTypeAudio") ?? UIImage()
        static let emailCloudFileIconDoc = UIImage(named: "fileTypeDoc") ?? UIImage()
        static let emailCloudFileIconFile = UIImage(named: "fileTypeFile") ?? UIImage()
        static let emailCloudFileIconImg = UIImage(named: "fileTypeImg") ?? UIImage()
        static let emailCloudFileIconJpg = UIImage(named: "fileTypeJpg") ?? UIImage()
        static let emailCloudFileIconPdf = UIImage(named: "fileTypePdf") ?? UIImage()
        static let emailCloudFileIconPng = UIImage(named: "fileTypePng") ?? UIImage()
        static let emailCloudFileIconVideo = UIImage(named: "fileTypeVideo") ?? UIImage()
        static let emailCloudFileIconXls = UIImage(named: "fileTypeXls") ?? UIImage()
        static let emailCloudFileTypeTxt = UIImage(named: "fileTypeTxt") ?? UIImage()

        static let chevronDownL = UIImage(named: "chevronL") ?? UIImage()
        static let chevronDownD = UIImage(named: "chevronD") ?? UIImage()

        static let chevronUpL = UIImage(named: "chevronUpL") ?? UIImage()
        static let chevronUpD = UIImage(named: "chevronUpD") ?? UIImage()

        static let chevronRightL = UIImage(named: "chevronRightL") ?? UIImage()
        static let chevronRightD = UIImage(named: "chevronRightD") ?? UIImage()

        static let oneEmailDetailsFoto1 = UIImage(named: "foto1") ?? UIImage()
        static let oneEmailDetailsFoto2 = UIImage(named: "foto2") ?? UIImage()

        static let oneEmailDetailsExample = UIImage(named: "example") ?? UIImage()

        static let oneEmailDetailsDownloadL = UIImage(named: "downloadL") ?? UIImage()
        static let oneEmailDetailsDownloadD = UIImage(named: "downloadD") ?? UIImage()

        static let oneEmailDetailsQuattroL = UIImage(named: "QuattroL") ?? UIImage()
        static let oneEmailDetailsQuattroD = UIImage(named: "QuattroD") ?? UIImage()

        static let oneEmailDetailsReply = UIImage(named: "replyBtn") ?? UIImage()
        static let oneEmailDetailsReplyToAll = UIImage(named: "replyToAllBtn") ?? UIImage()
        static let oneEmailDetailsForward = UIImage(named: "forwardBtn") ?? UIImage()

        static let imageFullScreenThreeDotsWhiteIcon24x24 = UIImage(named: "threeDotsIconWhite24x24") ?? UIImage()

        static let attachmentNavBarIcon18x20L = UIImage(named: "attachmentNavBarIcon18x20L") ?? UIImage()
        static let attachmentNavBarIcon18x20D = UIImage(named: "attachmentNavBarIcon18x20D") ?? UIImage()
        static let newEmailCreatePlaneNavBarIconL = UIImage(named: "planeNavBarIconL") ?? UIImage()
        static let newEmailCreatePlaneNavBarIconD = UIImage(named: "planeNavBarIconD") ?? UIImage()
        static let newEmailCreateRectTemplateAvatarIconL = UIImage(named: "rectTemplateAvatarIconL") ?? UIImage()
        static let newEmailCreateRectTemplateAvatarIconD = UIImage(named: "rectTemplateAvatarIconD") ?? UIImage()
        static let threeDotsNavBarIcon4x16L = UIImage(named: "threeDotsNavBarIcon4x16L") ?? UIImage()
        static let threeDotsNavBarIcon4x16D = UIImage(named: "threeDotsNavBarIcon4x16D") ?? UIImage()

        static let archiveIcon24x24L = UIImage(named: "archiveNavBarIcon24x24L") ?? UIImage()
        static let archiveIcon24x24D = UIImage(named: "archiveNavBarIcon24x24D") ?? UIImage()
        static let archiveIcon24x24Blue = UIImage(named: "archiveIcon24x24Blue") ?? UIImage()

        static let trashIcon24x24L = UIImage(named: "trashIcon24x24L") ?? UIImage()
        static let trashIcon24x24D = UIImage(named: "trashIcon24x24D") ?? UIImage()
        static let trashIcon24x24Blue = UIImage(named: "trashIcon24x24Blue") ?? UIImage()

        static let emailPickingScreenUnreadNavBarIcon24x24L = UIImage(named: "unreadNavBarIcon24x24L") ?? UIImage()
        static let emailPickingScreenUnreadNavBarIcon24x24D = UIImage(named: "unreadNavBarIcon24x24D") ?? UIImage()
        static let emailPickingScreenThreeDotsNavBarIcon24x24L = UIImage(named: "threeDotsNavBarIcon24x24L") ?? UIImage()
        static let emailPickingScreenThreeDotsNavBarIcon24x24D = UIImage(named: "threeDotsNavBarIcon24x24D") ?? UIImage()

        static let notPickedAvatarL = UIImage(named: "notPickedAvatarL") ?? UIImage()
        static let notPickedAvatarD = UIImage(named: "notPickedAvatarD") ?? UIImage()
        static let emailPickedScreenAvatarBoth = UIImage(named: "pickedAvatarBoth") ?? UIImage()
        static let emailPickedScreenNotCheckedBoxL = UIImage(named: "notCheckedBoxL") ?? UIImage()


        static let searchIcon24x24L = UIImage(named: "searchNavBarIcon24x24L") ?? UIImage()
        static let searchIcon24x24D = UIImage(named: "searchNavBarIcon24x24D") ?? UIImage()
        static let searchIcon24x24Blue = UIImage(named: "searchIcon24x24Blue") ?? UIImage()

        static let addressBookCheckmarkNavBarIcon24x24L = UIImage(named: "checkmarkNavBarIcon24x24L") ?? UIImage()
        static let addressBookCheckmarkNavBarIcon24x24D = UIImage(named: "checkmarkNavBarIcon24x24D") ?? UIImage()
        static let addressBookGreenCheckmarkNavBarIcon24x24Both = UIImage(named: "greenCheckmarkNavBarIcon24x24Both") ?? UIImage()

        static let emailTabIcon24L = UIImage(named: "emailTabIcon24L") ?? UIImage()
        static let emailTabIcon24D = UIImage(named: "emailTabIcon24D") ?? UIImage()
        static let emailTabIconSelected = UIImage(named: "emailTabIconSelected") ?? UIImage()

        static let profileTabIconL = UIImage(named: "profileTabIconL") ?? UIImage()
        static let profileTabIcon24D = UIImage(named: "profileTabIcon24D") ?? UIImage()
        static let profileTabIconSelected = UIImage(named: "profileTabIconSelected") ?? UIImage()


        static let changePinCodeUserProfile24L = UIImage(named: "ChangePinCodeUserProfile24L") ?? UIImage()
        static let changePinCodeUserProfile24D = UIImage(named: "ChangePinCodeUserProfile24D") ?? UIImage()

        static let signatureUserProfile24L = UIImage(named: "SignatureUserProfile24L") ?? UIImage()
        static let signatureUserProfile24D = UIImage(named: "SignatureUserProfile24D") ?? UIImage()

        static let reportOrDraftIcon24L = UIImage(named: "reportOrDraftIcon24L") ?? UIImage()
        static let reportOrDraftIcon24D = UIImage(named: "reportOrDraftIcon24D") ?? UIImage()
        static let reportOrDraftIcon24Blue = UIImage(named: "reportOrDraftIcon24Blue") ?? UIImage()

        static let unsafeOutputAlertUserProfile24L = UIImage(named: "UnsafeOutputAlertUserProfile24L") ?? UIImage()
        static let unsafeOutputAlertUserProfile24D = UIImage(named: "UnsafeOutputAlertUserProfile24D") ?? UIImage()

        static let darkThemeUserProfile24L = UIImage(named: "DarkThemeUserProfile24L") ?? UIImage()
        static let darkThemeUserProfile24D = UIImage(named: "DarkThemeUserProfile24D") ?? UIImage()

        static let infoUserProfile24L = UIImage(named: "InfoUserProfile24L") ?? UIImage()
        static let infoUserProfile24D = UIImage(named: "InfoUserProfile24D") ?? UIImage()

        static let incomingIcon24L = UIImage(named: "incomingIcon24L") ?? UIImage()
        static let incomingIcon24D = UIImage(named: "incomingIcon24D") ?? UIImage()
        static let incomingIcon24Blue = UIImage(named: "incomingIcon24Blue") ?? UIImage()

        static let sentIcon24L = UIImage(named: "sentIcon24L") ?? UIImage()
        static let sentIcon24D = UIImage(named: "sentIcon24D") ?? UIImage()
        static let sentIcon24Blue = UIImage(named: "sentIcon24Blue") ?? UIImage()

        static let outgoingIcon24L = UIImage(named: "outgoingIcon24L") ?? UIImage()
        static let outgoingIcon24D = UIImage(named: "outgoingIcon24D") ?? UIImage()
        static let outgoingIcon24Blue = UIImage(named: "outgoingIcon24Blue") ?? UIImage()

        static let sideMenuAttachmentIcon24L = UIImage(named: "sideMenuAttachmentIcon24L") ?? UIImage()
        static let sideMenuAttachmentIcon24D = UIImage(named: "sideMenuAttachmentIcon24D") ?? UIImage()
        static let sideMenuAttachmentIcon24Blue = UIImage(named: "sideMenuAttachmentIcon24Blue") ?? UIImage()

        static let gearIcon24L = UIImage(named: "gearIcon24L") ?? UIImage()
        static let gearIcon24D = UIImage(named: "gearIcon24D") ?? UIImage()
        static let gearIcon24Blue = UIImage(named: "gearIcon24Blue") ?? UIImage()
    }

    enum Margins {
        static let small1px: CGFloat = 1
        static let small2px: CGFloat = 2
        static let small4px: CGFloat = 4
        static let small6px: CGFloat = 6

        static let medium8px: CGFloat = 8
        static let medium10px: CGFloat = 10
        static let medium12px: CGFloat = 12
        static let medium14px: CGFloat = 14
        static let medium16px: CGFloat = 16
        static let medium18px: CGFloat = 18

        static let large20px: CGFloat = 20
        static let large22px: CGFloat = 22
        static let large23px: CGFloat = 23
        static let large24px: CGFloat = 24
        static let large26px: CGFloat = 26
        static let large30px: CGFloat = 30
        static let large32px: CGFloat = 32

        static let huge36px: CGFloat = 36
        static let huge40px: CGFloat = 40
        static let huge42px: CGFloat = 42
        static let huge48px: CGFloat = 48
        static let huge56px: CGFloat = 56
    }
}

