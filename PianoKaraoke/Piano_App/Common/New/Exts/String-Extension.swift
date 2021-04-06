//
//  String-Extension.swift
//  azibai
//
//  Created by  Hoan  vu on 5/8/17.
//  Copyright © 2017 azibai. All rights reserved.
//

import Foundation
import UIKit

private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]
func removeSpace(_ string: String) -> String{
    var str: String = String(string[string.startIndex])
    for (index,value) in string.enumerated(){
        if index > 0 {
            if value == " " {
                continue
            }
            if string[index - 1] == " " {
                str.append(value.uppercased())
            } else {
                str.append(value)
            }
        }
    }
    return str
}

extension String {
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    func convertToEthnicLanguage() -> String {
        var text = self
        text = text.replacingOccurrences(of: "đ", with: "d")
        text = text.replacingOccurrences(of: "Đ", with: "D")
        let data = text.data(using: .ascii, allowLossyConversion: true)
        guard let str = String(data: data!, encoding: String.Encoding.ascii) else { return "" }

        return str
    }

    func formatPhoneNumber(shouldRemoveLastDigit: Bool = false) -> String {
        let phoneNumber: String = self
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")

        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }

        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }

        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)

        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }

        return number
    }
    func isNumber() -> Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    
    func callPhoneNumber() {
        
        let phoneNumber = self.replacingOccurrences(of: "+84", with: "0")
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func isUrlFormat() -> Bool {
        return self.hasPrefix("http://")
    }
    
    func convertUrl() -> URL? {
        
        if self.isUrlFormat() {
            return URL(string: self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)
        }
        else if self.isUrlFormat_https() {
            return URL(string: self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)
        }
        else if self.isUrlFormat_file() {
            return URL(string: self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)
        }
        return nil
    }
    
    func isUrlFormat_file() -> Bool {
        return self.hasPrefix("file:///")
    }
    
    func isUrlFormat_https() -> Bool {
        return self.hasPrefix("https://")
    }
    
    
//    func isFormatLinkImage() -> Bool {
//        return self.hasPrefix(APIHelper.ImageURL.absoluteString)
//    }
    
    func isEqualData(_ string: String) -> Bool {
        if self == string {
            return true
        }
        return false
    }
    
    var length: Int {
        
        return self.count
    }
    
    
    
    // get value at index
    
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        let range_of = start..<end
        let mySubstring = self[range_of]  // play
        return String(mySubstring)
    }
    
    var stringByDecodingHTMLEntities : String {
        
        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(String(self[position ..< ampRange.lowerBound]))
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(String(entity)) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(String(entity))
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.append(String(self[position ..< endIndex]))
        
        do {
            let regex =  "<[^>]+>"
            let expr = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
            let replacement = expr.stringByReplacingMatches(in: result, options: [], range: NSMakeRange(0, result.count), withTemplate: "")
            
            return replacement
            //replacement is the result
        } catch {
            return result
            // regex was bad!
        }
    }
    
    func htmlDecoded()->String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        let entities = [ //a dictionary of HTM/XML entities.
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "&deg;"     : "º",
            "&rsquo;"   : "'",
            ]
        
        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
}

extension String {
    func getHeight(constraintedWidth width: CGFloat, font: UIFont, lines: Int) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = lines
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
    
}

extension String {
    
    
    func lastPartOfUrl() -> String
    {
        let fileArray = self.components(separatedBy: "/")
        return fileArray.last ?? ""
    }
    
    func lastItemPath() -> String{
        var typeImage = "gif"
        let linkImage = self.convertUrl()
        if let lasttype = linkImage?.lastPathComponent,lasttype.components(separatedBy: ".").count > 1{
            let arrItem = lasttype.components(separatedBy: ".")
            typeImage = arrItem[1]
        }
        return typeImage
    }
    
}
public extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap {
            $0 as? [String: Any]
        }
    }
    
    var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(self)
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

public extension Decodable {
    func from(json: String, using encoding: String.Encoding = .utf8) -> Self? {
        guard let data = json.data(using: encoding) else { return nil }
        return from(data: data)
    }
    
    func from(data: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(Self.self, from: data)
    }
}
