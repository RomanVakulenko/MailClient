//
//  ImageManager.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.04.2024.
//
import UIKit

enum ImageManager {

    static func isFileImagePreviewable(fileExtension: String) -> Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "bmp"]
        return imageExtensions.contains(fileExtension.lowercased())
    }

    static func createIcon(for name: String, backCellViewColor: UIColor, backColorOfImage: UIColor, width: CGFloat, height: CGFloat, completion: @escaping (UIImage?) -> Void) {

        DispatchQueue.main.async {
            let container = UIView()
            container.frame.size = CGSize(width: width, height: height)
            container.layer.backgroundColor = backCellViewColor.cgColor
            container.clipsToBounds = true

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = container.frame.size.width / 2
            imageView.frame = container.bounds
            imageView.clipsToBounds = true
            imageView.backgroundColor = backColorOfImage
            container.addSubview(imageView)

            let label = UILabel()
            label.text = String(name.prefix(1))
            label.textColor = UIColor.white
            label.font = UIFont(name: "Roboto-Bold", size: 18)
            label.textAlignment = .center
            label.frame = container.bounds
            imageView.addSubview(label)

            func makeImage(from view: UIView) -> UIImage? {
                UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
                guard let context = UIGraphicsGetCurrentContext() else {
                    Log.i("Failed to create image from view")
                    return nil
                }
                view.layer.render(in: context)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                return image
            }

            completion(makeImage(from: container))
        }
    }

    enum FileIcon {
        case audio
        case doc
        case file
        case img
        case jpg
        case pdf
        case png
        case vid
        case xls
        case txt
    }

    static func getFileIcon(for fileExtension: String) -> UIImage {
        switch fileExtension.lowercased() {
        case "audio", "mp3":
            return UIHelper.Image.emailCloudFileIconAudio
        case "doc","docx" :
            return UIHelper.Image.emailCloudFileIconDoc
        case "file", "jsf":
            return UIHelper.Image.emailCloudFileIconFile
        case "img":
            return UIHelper.Image.emailCloudFileIconImg
        case "jpg", "jpeg":
            return UIHelper.Image.emailCloudFileIconJpg
        case "pdf":
            return UIHelper.Image.emailCloudFileIconPdf
        case "png":
            return UIHelper.Image.emailCloudFileIconPng
        case "video", "mp4":
            return UIHelper.Image.emailCloudFileIconVideo
        case "xls":
            return UIHelper.Image.emailCloudFileIconXls
        case "txt":
            return UIHelper.Image.emailCloudFileTypeTxt
        default:
            return UIImage() // Возвращаем пустую иконку для неизвестного расширения
        }
    }
}


