//
//  Helper.swift
//  Azibai
//
//  Created by ToanHT on 8/24/20.
//  Copyright © 2020 Azi IOS. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
func Log(_ s: CustomStringConvertible, file: String = #file, line: Int = #line) {
    #if DEBUG
    let fileName = file.components(separatedBy: "/").last!
    let date = Date().toString(withFormat: "HH:mm:ss")
    print("==>>> [\(date) \(fileName) L\(line) T\(Thread.current)] \(s)")
    #endif
}

final class Helper {
    static var kCacheAPI_MEProfile = "kCacheAPI_MEProfile"
    
    static func getImagePickerController(withType type: [String]? = nil, videoQuality: UIImagePickerController.QualityType = .typeMedium) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        if let tempType = type {
            pickerController.mediaTypes = tempType
            pickerController.videoQuality = videoQuality
        }
        return pickerController
    }

    static func getNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter
    }

    static func getHeightFrom(imageWidth: CGFloat, targetSize: CGSize) -> CGFloat {
        return (imageWidth * targetSize.height) / targetSize.width
    }
    
    static func getAttributesStringWithFontAndColor(string: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes:
            [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : color])
    }
    
    static func cacheJsonAPI(with path: String, dataJSON: JSON) {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(path)
        if let data = dataJSON.description.data(using: .utf8) {
            if (try? data.write(to: url)) != nil {
                Log("Cache Data success at : \(url)")
            }
        }
    }
    
    static func loadCacheJsonAPI(with path: String) -> Dictionary<String, Any>? {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(path)
        if let data = try? Data.init(contentsOf: url) {
            if let json = try? JSON(data: data) {
                Log(json.dictionaryValue)
                return json.dictionaryValue
                //                let news = json.arrayValue.compactMap({ News(json: $0) })
                //                return news
            }
        }
        return nil
    }
    
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension MutableCollection {
    subscript(safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[ index] : nil
        }

        set(newValue) {
            if let newValue = newValue, indices.contains(index) {
                self[ index] = newValue
            }
        }
    }
}
