//
//  UploadImageModel.swift
//  SwiftNetWorkArch
//
//  Created by macode on 2022/1/13.
//

import UIKit

public struct UploadImageModel {
    public enum ImageFormat: String {
        case gif
        case jpeg
        case png
        case unknown
    }
    public var imageData: Data
    public var imageFormat = ImageFormat.unknown
    public var type: String = "avatar"
    public var fromCamera = false
    public var usescenes: String? = nil
    public var uploadUrl: String = "http://www.baidu.com/v1/file/upload/"
    
    public init(imageData: Data, imageFormat: UploadImageModel.ImageFormat) {
        self.imageData = imageData
        self.imageFormat = imageFormat
    }
}
