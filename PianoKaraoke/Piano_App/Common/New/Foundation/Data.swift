//
//  Data.swift
//  Azibai
//
//  Created by Apple on 7/26/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//
import UIKit
extension Data {
    
    var isAnimatedImage: Bool {
        if let source = CGImageSourceCreateWithData(self as CFData, nil) {
            let count = CGImageSourceGetCount(source)
            return count > 1
        }
        return false
    }
    
//    private static let mimeTypeSignatures: [UInt8 : String] = [
//        0xFF : "image/jpeg",
//        0x89 : "image/png",
//        0x47 : "image/gif",
//        0x49 : "image/tiff",
//        0x4D : "image/tiff",
//        0x25 : "application/pdf",
//        0xD0 : "application/vnd",
//        0x46 : "text/plain",
//    ]
//    
//    var mimeType: String {
//        var c: UInt8 = 0
//        copyBytes(to: &c, count: 1)
//        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
//    }
}
