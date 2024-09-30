//
//  Rus.swift
// 01.04.2024.
//

extension InterfaceTranslation {
    func getRU() -> String {
        switch self {
        case .initialTitle: return "Почта\n"
        case .initialTitleVersion: return "v 1.0"
        case .aboutAppCERTEX: return "Почта\nВерсия: "

        case .logInRegistrLoadKeysFromPhone: return "Загрузить файл ключей с телефона"
        case .logInRegistrScanQRKode: return "Сканировать QR-код "
        case .registrationTitle: return "Регистрация"

        case .pinCodeTitle: return "Вход в приложение"
        case .enterPin: return "Введите ПИН-код" //universal

        case .enterPasswordTitle: return "Ввод пароля"
        case .enterPasswordSubTitle: return "Введите пароль QR-кода"
        case .enterPasswordRectangleTitle: return "Введите пароль"
        case .enterPasswordNextStep: return "Следующий шаг"

        case .enterQRPasswordSubTitle: return "Введите пароль к Вашему файлу ключей"
        case .enterQRPasswordBorderTitle: return "Введите пароль от файла ключей"
        case .enterQRPasswordNextStep: return "Следующий шаг"

        case .secretKeySelectorTitle: return "Выбор файла ключей"
        case .secretKeySelectorSubTitle: return "Для выбора файла ключей нажмите на кнопку Обзор..."
        case .secretKeySelectorPlaceholderOrBorderTitle: return "Введите пароль от файла ключей"
        case .secretKeySelectorBrowseTitle: return "Обзор..."
        case .secretKeySelectorBiometryAlert: return "Не удалось подключить биометрию"

        case .error: return "Ошибка"

        case .errorAtMovingToSentFolder: return "Не удалось переместить в папку Отправленные"
        case .errorAtMovingToDraftsFolder: return "Не удалось переместить в папку Черновики"
        case .errorAtMovingToDeletedFolder: return "Не удалось переместить в папку Удаленные"
        case .errorAtMovingToArchivedFolder: return "Не удалось переместить в папку Архив"
        case .errorAtGettingMail: return "Не удалось получить письмо"
        case .doYouWantToDelete: return """
                                        Вы уверены, что хотите переместить письмо в "Удаленные"?
                                        """
        case .doYouWantToArchive: return """
                                         Вы уверены, что хотите переместить письмо в "Архив"?
                                         """
        case .movedSuccessfully: return "Перемещение совершено успешно"

        case .closeAction: return "Оk"
        case .secretKeySelectorBrowseAlert: return "Файл не может быть открыт"

        case .setPinCodeTitle: return "Установка ПИН-кода"
        case .setPinCodeSubTitle: return "Задайте ПИН-код для входа в приложение. В случае утери ПИН-кода данные на этом устройстве будут недоступны"
        case .setPinCodeToggleTitle: return "Разрешить вход в приложение с использованием биометрической идентификации"
        case .confirmEnterPin: return "Подтвердите ПИН-код" //universal
        case .setPinCodeFinishRegistration: return "Завершение регистрации"

        case .mailStartScreenTitle: return "Входящие"
        case .mailStartScreenCloudNewEmailTitle: return "Новое"
        case .messagesAlert: return "Не удается загрузить письма"

        case .oneEmailDetailsUpperViewReceivedSubTitle: return "Получено: "
        case .oneEmailDetailsUpperViewFromTitle: return "от: "
        case .oneEmailDetailsUpperViewToTitle: return "кому: "
        case .oneEmailDetailsUpperViewDidSendTitle: return "отправлено: "
        case .oneEmailDetailsUpperViewDidReceiveTitle: return "получено: "
        case .oneMessageAlert: return "Не удается загрузить письмо"

        case .oneEmailDetailsAttachedFilesTitle: return "Вложенные файлы"
        case .oneEmailAttachedFotoTitle: return "Вложенные фото"

        case .reply: return "Ответить"
        case .replyToAll: return "Ответить всем"
        case .forward: return "Переслать"
        case .oneEmailDetailsSwipeInstruction: return "Для перехода к следующему письму сдвиньте экран влево. Для перехода к предыдущему письму сдвиньте экран вправо"

        case .imageFullScreenDownloadImage: return "Скачать фото"
        case .imageFullScreenOpenInOtherApp: return "Открыть в другом приложении"

        case .newEmailCreateUpperViewFromTitle: return "Oт:"
        case .newEmailCreateUpperViewToTitle: return "Кому:"
        case .newEmailCreateUpperViewCopyTitle: return "Копия:"
        case .newEmailCreateUpperViewThemeTitle: return "Тема:"
        case .newEmailCreateScreenTitle: return "Новое письмо"
        case .newEmailCreateScreenSendButtonTitle: return "Отправить"

        case .newEmailCreatePlaceholderToCopy: return "Введите email"
        case .newEmailCreatePlaceholderTheme: return "Введите тему"

        case .newEmailCreateThreeDotsMenuDeleteLabel: return "Удалить письмо"
        case .newEmailCreateThreeDotsMenuSaveDraftLabel: return "Сохранить черновик"

        case .newEmailCreateAttachFileLabel: return "Прикрепить файл..."
        case .newEmailCreateChooseFоtoFromGalleryLabel: return "Выбрать фото из галереи"
        case .newEmailCreateTextViewPlaceholder: return "Текст сообщения"
        case .newEmailCreateCanNotGetFileOrFoto: return "Не удалось загрузить файл или фото"
        case .newEmailCreateAlertAtToField: return """
                                                   В поле "Кому" введен некорректный эл. адрес
                                                   """
        case .newEmailCreateAlertAtCopyField: return """
                                                   В поле "Копия" введен некорректный эл. адрес
                                                   """
        case .newEmailCreateAlertAtAddingFiles: return "Не удалось добавить фото или файл"
        case .newEmailCreateSendingOk: return """
                                              Письмо успешно перемещено в папку "Исходящие"
                                              """

        case .newEmailCreateSavingDraft: return """
                                                  Сохранить в "Черновики"?
                                                (иначе письмо будет утеряно)
                                                """
        case .newEmailCreateSendingFailed: return """
                                                  Письмо не перемещено в папку "Исходящие", причина:
                                                  """
        case .newEmailCreateToFieldIsEmpty: return """
                                                   Поле "Кому" пустое
                                                   """
        case .newEmailCreateNotAbleToAddFiles: return "Не удалось добавить фото или файл"
        case .newEmailCreateFileSizeIsBiggerThanLimit: return "Файл больше 50Mb нельзя добавить!"
        case .emailPickingScreenCheckBoxTitlePickAll: return "Выбрать все"
        case .markEmailAsRead: return  "Пометить как прочитанное"
        case .markEmailAsUnread: return  "Пометить как непрочитанное"

        case .moveEmailTo: return  "Переместить в..."
            
        case .alreadySentMessage: return  "Отправленные"
        case .draftMessages: return  "Черновики"
        case .archivedMessages: return  "Архив"
        case .deletedMessages: return  "Удаленные"

        case .someNotification: return "Уведомление"
        case .сancelTitle: return  "Отмена"
        case .saveTitle: return  "Сохранить"
        case .closeTitle: return  "Закрыть"

        case .addressBookScreenTitle: return "Адресная книга"
        case .addressBookCantGetAddressesAndNames: return "Не удалось получить контакты с эл.адресами"
        case .searchViewPlaceholder: return "Введите для поиска"
        case .attachmentsTitle: return  "Вложения"

        case .emailsTabBarItemTitle: return "Сообщения"

        case .userProfileTitle: return "Профиль"
        case .userProfileChangePinCode: return "Сменить ПИН-код"
        case .userProfileSignature: return "Подпись"
        case .userProfileReport: return "Отправить отчет о работе приложения"
        case .userProfileDeleteMailForServer: return "Удалять сообщения с сервера"
        case .userProfileUnsafeOutputAlert: return "Предупреждать при передаче сообщений на незащищенные системы"
        case .userProfileDarkTheme: return "Темная тема"
        case .aboutAppTitle: return "О приложении"
        case .aboutAppCopyRights: return "Все права защищены "
        case .changeUserNameTitle: return "Изменение имени"
        case .userNameSubtitle: return "Имя пользователя"
        case .senderNameTitleAtBorded: return "Имя отправителя"

        case .userProfileChangePinCodeTitle: return "Смена ПИН-кода"
        case .userProfileEnterCurrentPinCode: return "Введите текущий ПИН-код"
        case .userProfileEnterNewPinCode: return "Введите новый ПИН-код"
        case .userProfileConfirmNewPinCode: return "Подтвердите новый ПИН-код"

        case .userProfileSetSingnaturePlaceholder: return "Введите подпись"
        case .userProfileSendReportTitleAndSubject: return "Отчет о работе приложения"

        case .outgoingMessages: return "Исходящие"
        case .settingsTitle: return "Настройки"
        case .searchContactsAtWeb: return "Поиск контактов на сервере"
        case .searchContacts: return "Поиск контактов"
        case .searchTitleForTabBarItem: return "Поиск"

        case .oneContactDetailsTitle: return "Информация о контакте"
        case .oneContactDetailsEmailTitle: return "Email:"
        case .oneContactDetailsPhoneTitle: return "Телефон:"
        case .oneContactDetailsIINTitle: return "ИИН:"
        case .oneContactDetailsInvalidPhoneNumber: return "Номер телефона некорректный"

        }
    }
}



