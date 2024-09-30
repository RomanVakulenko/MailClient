//
//  FileShareable.swift
// 01.11.2023.
//

import UIKit

protocol FileShareable {
    func shareFile(url: URL, from viewController: UIViewController)
    func shareFile(data: Data, filenameWithExt: String, from viewController: UIViewController)
}

extension FileShareable {
    func shareFile(url: URL, from viewController: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view // Если используется на iPad
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareFile(data: Data, filenameWithExt: String, from viewController: UIViewController) {
        let tempDirectory = NSTemporaryDirectory()
        let tempURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(filenameWithExt)
        Log.i(tempURL.absoluteString)
        Log.i("try to write file")
        do {
            try data.write(to: tempURL, options: .atomic)
            Log.i("try success")
            shareFile(url: tempURL, from: viewController)
        } catch {
            Log.e("An error occurred while writing the data to the temp URL: \(error)")
        }
    }
    
}

// Пример использования:
// class SomeViewController: UIViewController, FileSharing {
//     func someMethod() {
//         let fileData: Data = ... // Получите данные файла, который вы хотите поделиться
//         shareFile(data: fileData, filename: "example.txt", from: self)
//     }
// }
