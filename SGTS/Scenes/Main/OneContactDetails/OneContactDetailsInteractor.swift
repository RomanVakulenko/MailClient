//
//  OneContactDetailsInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 31.07.2024.
//

import Foundation

protocol OneContactDetailsBusinessLogic {
    func onDidLoadViews(request: OneContactDetailsFlow.OnDidLoadViews.Request)
    func didTapAtEmailAddress(request: OneContactDetailsFlow.OnTapEmailAddress.Request)
    func didTapAtPhone(request: OneContactDetailsFlow.OnTapPhone.Request)
}

protocol OneContactDetailsDataStore: AnyObject {
    var fullName: String { get }
    var emailAddress: String? { get }
    var phoneNumber: String? { get }
    var iin: String? { get }

    var onePickedEmailAddress: String { get }
//    var allEmailsInDataBase: [String] { get } //нужно, если будем возвращаться сразу в поле кому/копия
    var isMultiPickingMode: Bool { get }
}


final class OneContactDetailsInteractor: OneContactDetailsBusinessLogic, OneContactDetailsDataStore {

    // MARK: - Public properties
    var presenter: OneContactDetailsPresentationLogic?
    var worker: OneContactDetailsWorkingLogic?

    var fullName: String = ""
    var emailAddress: String?
    var phoneNumber: String?
    var iin: String?

    var onePickedEmailAddress: String = ""
//    var allEmailsInDataBase: [String] //нужно, если будем возвращаться сразу в поле кому/копия
    var isMultiPickingMode: Bool

    // MARK: - Private properties

    private var contactStruct: ContactListItem

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(contactStruct: ContactListItem,
         isMultiPickingMode: Bool) {
        self.contactStruct = contactStruct
        self.isMultiPickingMode = isMultiPickingMode
    }

    // MARK: - Public methods

    func onDidLoadViews(request: OneContactDetailsFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        
        onePickedEmailAddress.append(contactStruct.email)
        phoneNumber = contactStruct.phone
        fullName = contactStruct.cn


        presenter?.presentUpdate(response: OneContactDetailsFlow.Update.Response(
            id: contactStruct.uid,
            fullName: contactStruct.cn,
            emailAddress: contactStruct.email,
            phoneNumber: contactStruct.phone,
            iin: contactStruct.iin))
    }

    func didTapAtEmailAddress(request: OneContactDetailsFlow.OnTapEmailAddress.Request) {
        Log.i("pressed EmailAddress")
        presenter?.presentRouteBackToAddressBook(response: OneContactDetailsFlow.RoutePayload.Response())
    }

    func didTapAtPhone(request: OneContactDetailsFlow.OnTapPhone.Request) {
        Log.i("pressed phone")
        if isValidPhoneNumber(phoneNumber) {
            presenter?.presentRouteToCallNumber(response: OneContactDetailsFlow.RoutePayload.Response())
        } else {
            Log.e("Неверный формат номера телефона: \(String(describing: phoneNumber))")
            presenter?.presentAlert(response: OneContactDetailsFlow.AlertInfo.Response())
        }
    }

    // MARK: - Private methods

    private func isValidPhoneNumber(_ phoneNumber: String?) -> Bool {
        let phoneRegex = #"^\+?(\d{1,3})?[-]?(\d{1,4})[-]?(\d{1,4})[-]?(\d{1,4})$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)

        guard let number = phoneNumber else { return false }
        // del all but "-"
        let digitsCount = number.replacingOccurrences(of: "-", with: "").filter { $0.isNumber }.count
        return phoneTest.evaluate(with: phoneNumber) && digitsCount >= 6
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                presenter?.presentUpdate(response: OneContactDetailsFlow.Update.Response(
                    id: contactStruct.uid,
                    fullName: contactStruct.cn,
                    emailAddress: contactStruct.email,
                    phoneNumber: contactStruct.phone,
                    iin: contactStruct.iin))
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                presenter?.presentUpdate(response: OneContactDetailsFlow.Update.Response(
                    id: contactStruct.uid,
                    fullName: contactStruct.cn,
                    emailAddress: contactStruct.email,
                    phoneNumber: contactStruct.phone,
                    iin: contactStruct.iin))
            }
    }
}
