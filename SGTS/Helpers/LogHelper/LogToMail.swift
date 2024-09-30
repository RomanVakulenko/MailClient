//
//  LogToMail.swift
// 07.11.2023.
//

import MessageUI
import CocoaLumberjack

// Это должно быть в том же классе, где вы настроили логгирование в файл
class LogToMail: NSObject, MFMailComposeViewControllerDelegate {
    
    static let shared = LogToMail()
    
    private override init() {
        super.init()
        startLoggingLumberjackToFile()
    }
    
    lazy var logFileManager = DDLogFileManagerDefault(logsDirectory: self.documentsDirectory)
    
    func touchFromInit() {
        print("start")
    }
    
    private func startLoggingLumberjackToFile() {
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        let logFileManager = self.logFileManager//DDLogFileManagerDefault(logsDirectory: documentsDirectory)
        
        let fileLogger: DDFileLogger = DDFileLogger(logFileManager: logFileManager)
        fileLogger.maximumFileSize = 5242880 // 5 mb
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 10 // pcs
        DDLog.add(fileLogger)
    }
    
    private var documentsDirectory: String {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return ""}
        return documentsDirectory.path
    }
    
    func sendLogsByEmail(from viewController: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            DDLogError("Mail services are not available")
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setSubject("Log files")
        mailComposeVC.setToRecipients(["someaddr@gmail.com"]) // Замените на актуальный email адрес
        
        // Получаем лог-файлы
        let logFilePaths = logFileManager.sortedLogFilePaths
        for logFilePath in logFilePaths {
            do {
                let fileData = try Data(contentsOf: URL(fileURLWithPath: logFilePath))
                mailComposeVC.addAttachmentData(fileData, mimeType: "text/plain", fileName: (logFilePath as NSString).lastPathComponent)
            } catch {
                DDLogError("Failed to attach log file with error: \(error.localizedDescription)")
            }
        }
        
        viewController.present(mailComposeVC, animated: true)
    }
    
    // Delegate method
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if let error = error {
                DDLogError("Error sending mail: \(error.localizedDescription)")
            } else {
                DDLogInfo("Mail sent result: \(result.rawValue)")
            }
        }
    }
}
