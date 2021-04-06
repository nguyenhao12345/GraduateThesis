//
//  Int.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Properties
extension Int {
    
    var uiColor: UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var cgColor: CGColor {
        return self.uiColor.cgColor
    }
    
    var int: Int {
        return Int(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var string: String {
        return "\(self)"
    }
    
    var stringZero: String {
        if(self == 0){
            return ""
        }
        return "\(self)"
    }
    
    var uInt: UInt {
        return UInt(self)
    }
    
    var countableRange: CountableRange<Int> {
        return 0..<self
    }
    
    var shortString: String {
        if self < 1000 {
            return self.string
        }
        else if self > 1000 && self < 999999 {
            let double = Double(self) / 1000
            return double.string + "K"
        }
        else {
            let double = Double(self) / 1000000
            return double.string + "M"
        }
    }
    
    var toDate: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        
        let days = (String((self / 86400)) + " Ngày")
        let hours = ((self % 86400) / 3600)
        let minutes = (self % 3600) / 60
        
        guard let hoursString = numberFormatter.string(from: NSNumber(value: hours)) else { return "" }
        guard let minutesString = numberFormatter.string(from: NSNumber(value: minutes)) else { return "" }
        return days + " \(hoursString):" + "\(minutesString):" + "00"
    }
}

extension Int64 {
    var stringWithCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self)) ?? ""
    }
    
    var stringWithCommasAllValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    var currency: String {
        return Currency.formatter.string(for: self) ?? ""
    }
}

extension Int {
    var stringWithCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        guard self > 0 else { return "" }
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Int {
    var stringWithCommasAllValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
