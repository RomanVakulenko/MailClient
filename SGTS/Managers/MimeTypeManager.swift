//
//  MimeTypeManager.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.08.2024.
//

import Foundation

enum MimeTypeManager {

    enum MimeType: String {
        case jpg, jpeg = "image/jpeg"
        case png = "image/png"
        case gif = "image/gif"
        case bmp = "image/bmp"
        case webp = "image/webp"
        case tiff = "image/tiff"
        case pdf = "application/pdf"
        case doc = "application/msword"
        case docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case xls = "application/vnd.ms-excel"
        case xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case ppt = "application/vnd.ms-powerpoint"
        case pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case txt = "text/plain"
        case html = "text/html"
        case css = "text/css"
        case js = "application/javascript"
        case json = "application/json"
        case xml = "application/xml"
        case zip = "application/zip"
        case rar = "application/x-rar-compressed"
        case _7z = "application/x-7z-compressed"
        case tar = "application/x-tar"
        case gz = "application/gzip"
        case mp3 = "audio/mpeg"
        case wav = "audio/wav"
        case mp4 = "video/mp4"
        case avi = "video/x-msvideo"
        case mkv = "video/x-matroska"

    }

    static func getMimeType(forExtension ext: String) -> String? {
        return MimeType(rawValue: ext)?.rawValue
    }
}
