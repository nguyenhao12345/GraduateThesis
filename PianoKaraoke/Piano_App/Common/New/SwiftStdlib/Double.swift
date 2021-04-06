//
//  Double.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
    
    var float: Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var int: Int {
        return Int(self)
    }
    
    var string: String {
        return "\(self)"
    }
    
    var toString: String {
        if self <= 0 {
            return ""
        }
        return "\(self)"
    }
    
    var toString2: String {
        if self <= 0 {
            return ""
        }
        return String(format: "%.0f", self)
    }
    
    
    
    func toMoney() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: self as NSNumber) ?? "0"
    }
    
    func toTimestampString(formatString: String = "dd/MM/yyyy HH:mm") -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: date)
    }
    
    var stringWithCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        guard self > 0 else { return "" }
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    var stringWithCommasAllValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    var clean: String {
        let newString = self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        guard newString != "0" else {
            return ""
        }
        return newString
    }
    
    func toActuallyMoneyFrom(percentNumber: Double) -> String {
        return Double(self - ((self * percentNumber) / 100)).stringWithCommas
    }
    
    
     func initTimeAgoSinceNow() -> String{
         return ""
//         var timeAgoSinceNow = ""
//         let format = "yyyy-MM-dd HH:mm:ss"
//         let dateString = self.toTimestampString(formatString: format)
//         let data = Date(dateString: dateString, format: format)
//
//         if data.daysAgo < 1 {   //Hôm nay
//             if data.minutesAgo < 60 {  // n phút trước
//                 timeAgoSinceNow = "\(data.minutesAgo) phút trước"
//             }
//             else if data.hoursAgo < 24 {    // n giờ trước
//                 timeAgoSinceNow =  "\(data.hoursAgo) giờ trước"
//             }
//
//         }
//         else {
//             if data.daysAgo < 2 {   //Hôm qua
//                 timeAgoSinceNow = "Hôm qua lúc " + data.hour.fillUp + ":" + data.minute.fillUp
//
//             }
//             else {
//                 if data.yearsAgo <= 1 {
//                     timeAgoSinceNow = data.day.fillUp +  " th" + data.month.fillUp + " lúc " +  data.hour.fillUp + ":" +  data.minute.fillUp
//                 }
//                 else {
//                     timeAgoSinceNow = "\(data.year.fillUp) " + data.day.fillUp + " th" + data.month.fillUp + " lúc " + data.hour.fillUp + ":" + data.minute.fillUp
//                 }
//             }
//         }
//         return timeAgoSinceNow
     }
}

