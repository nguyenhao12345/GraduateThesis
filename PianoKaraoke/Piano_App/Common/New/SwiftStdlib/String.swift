//
//  String.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Properties
extension String {
    
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isValidPhoneNumber: Bool {
        let regex = "^[0-9]{6,14}$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isValidUrl: Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    var isMp3 : Bool{
        return self.lowercased().contains("mp3") || self.lowercased().contains("mpga")
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    var rangeOfURLs: [NSRange] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
        return matches.compactMap({ $0.range })
    }
    
    var rangeOfHashtags: [NSRange] {
        if let regex = try? NSRegularExpression(pattern: "#(\\w+)", options: .caseInsensitive)
        {
            let string = self as NSString
            
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                //                string.substring(with: $0.range).replacingOccurrences(of: "#", with: "").lowercased()
                $0.range
            }
        }
        
        return []
    }
    
    var words: [String] {
        var words: [String] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            words.append(String(self[range]))
        }
        return words
    }
    
    var int: Int? {
        return Int(self)
    }
    
    var uiImage: UIImage? {
        return UIImage(named: self)
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func convertStringToPhoneNumber() -> String{
        
        var phone = self.trim()
        
        if phone.contains(")"){
            phone = phone.components(separatedBy: ")").last ?? ""
        }
        
//        if phone[0] != "0" {
//            phone = "0" + phone
//        }
        return phone
    }
}

// MARK: - NSString extensions
extension String {
    
    /// SwifterSwift: NSString from a string.
    var nsString: NSString {
        return NSString(string: self)
    }
    
    /// SwifterSwift: NSString lastPathComponent.
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    /// SwifterSwift: NSString pathExtension.
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    /// SwifterSwift: NSString deletingLastPathComponent.
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    /// SwifterSwift: NSString deletingPathExtension.
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    /// SwifterSwift: NSString pathComponents.
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    
    /// SwifterSwift: NSString appendingPathComponent(str: String)
    ///
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    /// SwifterSwift: NSString appendingPathExtension(str: String)
    ///
    /// - Parameter str: The extension to append to the receiver.
    /// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
}

// MARK: - Methods
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func isValidRange(_ range: NSRange) -> Bool {
        return count >= range.location + range.length
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

extension String {
    
    func range(ofText text: String) -> NSRange {
        let fullText = self
        let range = (fullText as NSString).range(of: text)
        return range
    }
}


func formatMoneyFromDoubleToString(tipAmount : Int) -> String{
    let formatter = NumberFormatter()

    formatter.numberStyle = .currency
    if let formattedTipAmount = formatter.string(from: tipAmount as NSNumber) {
        return formattedTipAmount
    }
    return formatter.string(from: 0)!
}

func df2so(_ price: Int64) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.groupingSeparator = "."
    numberFormatter.groupingSize = 3
    numberFormatter.usesGroupingSeparator = true
//    numberFormatter.decimalSeparator = "."
//    numberFormatter.numberStyle = .decimal
//    numberFormatter.maximumFractionDigits = 2
    return numberFormatter.string(from: price as NSNumber)!
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .unicode) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func htmlAttributed(font: UIFont) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(font.pointSize) !important;" +
                "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var strickAttributedString: NSAttributedString?{
        let textRange = NSMakeRange(0, self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle , value:  NSUnderlineStyle.single.rawValue, range: textRange)
        return attributedText
    }
    
    var dashString : NSAttributedString{
        return strickAttributedString ?? NSAttributedString(string: "")
    }
    
    var underAttributedString: NSAttributedString?{
        let textRange = NSMakeRange(0, self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value:  NSUnderlineStyle.single.rawValue, range: textRange)
        return attributedText
    }
    
//    var encodeToInt: Int {
//        let result = 0
//        for i in 0..<self.count - 1 {
//            _ = Character(self[i])
////            result += i + Int(c.asciiValue ?? 0)
//        }
//        return result
//    }
    
    var toInteger: Int {
        guard !self.isEmpty else {
            return 0
        }
        return Int(self)!
    }
    
    var toCGFloat: CGFloat {
        return CGFloat.init(self.toDouble)
    }
    var toDouble: Double {
        return NumberFormatter().number(from: self)?.doubleValue ?? 0
    }
    
    var stringCommasToDouble: Double {
        guard !self.isEmpty else {
            return 0
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let grade = numberFormatter.number(from: self)
        
        guard let doubleValue = grade?.doubleValue else { return 0 }
        return doubleValue
    }
}

extension String {
    
    func convertDateStringToTimeStamp(formatString: String = "dd/MM/yyyy HH:mm") -> Int? {
        let dfmatter = DateFormatter()
        dfmatter.timeZone = .current
        dfmatter.dateFormat = formatString
        guard let date = dfmatter.date(from: self) else {
            return nil
        }
        let timestamp: TimeInterval = date.timeIntervalSince1970
        return Int(timestamp)
    }
    
    func convertStringToDate(formatString: String = "dd/MM/yyyy HH:mm") -> Date? {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = formatString
        dfmatter.timeZone = TimeZone.current
        dfmatter.locale = .current
        guard let date = dfmatter.date(from: self) else {
            return nil
        }
        return date
    }
    
    func convertStringToDDMMYY() -> String {
         let dfmatter = DateFormatter()
         dfmatter.dateFormat = "dd/MM/yyyy"
         dfmatter.timeZone = TimeZone.current
         dfmatter.locale = .current
         guard let date = convertStringToDate(formatString: "yyyy/MM/dd HH:mm:ss") else {
             return ""
         }
        return dfmatter.string(from: date)
     }
    
    var toURL: URL! {
        if let url = URL(string: self) {
            return url
        } else if let escapedString = self.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) {
            return URL(string: escapedString)
        } else {
            return URL(string: self)
        }
    }
    
    var toMoney: String {
        let formatter = Helper.getNumberFormatter()
        if let groupingSeparator = formatter.groupingSeparator {
            let textWithoutGroupingSeparator = self.replacingOccurrences(of: groupingSeparator, with: "")
            if let numberWithoutGroupingSeparator = formatter.number(from: textWithoutGroupingSeparator),
                let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {
                return formattedText
            }
        }
        return self
    }
    
    func toMoney(currentString: String, textString: String?) -> (String, Bool) {
        let formatter = Helper.getNumberFormatter()
        if let groupingSeparator = formatter.groupingSeparator {
            if currentString == groupingSeparator {
                return (self, true)
            }
            
            if let textWithoutGroupingSeparator = textString?.replacingOccurrences(of: groupingSeparator, with: "") {
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + currentString
                if currentString.isEmpty { // pressed Backspace key
                    totalTextWithoutGroupingSeparators.removeLast()
                }
                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                    let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {
                    
                    return (formattedText, false)
                }
            }
        }
        return (self,true)
    }
    
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    func toActuallyMoneyFrom(percentNumber: Double) -> String {
        return Double(self.stringCommasToDouble - ((self.stringCommasToDouble * percentNumber) / 100)).stringWithCommas
    }
    
    var isValidLimitMoney: Bool {
        return self.stringCommasToDouble <= 99000000000
    }
}

extension String {
    subscript(_ range: NSRange) -> String {
        let subString = (self as NSString).substring(with: range)
        return String(subString)
    }
    
    
    func convertJSONStringToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

extension String {
    func totalLine(font : UIFont, width : CGFloat) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude);
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil);
        return Int(boundingBox.height/font.lineHeight);
    }
}

extension String {
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    
    func substring(toEnd : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: toEnd)
        return String(self[...toIndex])
    }
    
    func getLatestStringBySpecialCharacter(stringCharacters characters: String) -> String {
        guard let range: Range<String.Index> = self.range(of: characters) else { return self }
        let index: Int = self.distance(from: self.startIndex, to: range.lowerBound)
        guard index != 0 else { return self }
        
        let stringBeforeCharacters = self.substring(toEnd: index - 1)
        
        guard stringBeforeCharacters.count > 20 else { return self }
        
        let stringLimitBy21Characters = stringBeforeCharacters.suffix(from: stringBeforeCharacters.index(stringBeforeCharacters.endIndex, offsetBy: -21))
        
        guard stringLimitBy21Characters.prefix(1) != " " else {
            let endString = String(stringLimitBy21Characters + self.substring(from: index)).trimmingCharacters(in: .whitespacesAndNewlines)
            return "..." + endString
        }
        
        guard let rangeSpace: Range<String.Index> = stringLimitBy21Characters.range(of: " ") else { return self }
        let indexOfSpace: Int = stringLimitBy21Characters.distance(from: stringLimitBy21Characters.startIndex, to: rangeSpace.lowerBound)
        let endString = String(String(stringLimitBy21Characters).substring(from: indexOfSpace) + self.substring(from: index)).trimmingCharacters(in: .whitespacesAndNewlines)
        
        return "..." + endString
    }
    
    func attributedStringWithFont(_ strings: [String], font: UIFont, characterSpacing: UInt? = nil) -> NSAttributedString {
              let attributedString = NSMutableAttributedString(string: self)
              for string in strings {
                  let range = (self as NSString).range(of: string)
                  attributedString.addAttribute(NSAttributedString.Key.font, value: font
                      , range: range)
              }
              
              guard let characterSpacing = characterSpacing else {return attributedString}
              
              attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
              
              return attributedString
          }
}
