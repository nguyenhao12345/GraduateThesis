//
//  Int-Extension.swift
//  azibai
//
//  Created by HoanVu on 6/22/17.
//  Copyright © 2017 azibai. All rights reserved.
//

import Foundation
import UIKit

extension NumberFormatter {
    convenience init(style: Style) {
        self.init()
        self.numberStyle = style
    }
}

struct Currency {
    static let formatter = NumberFormatter(style: .decimal)
}
extension Double {
    var currency: String {
        return Currency.formatter.string(for: self) ?? ""
    }
}
extension Int {
    
    var fillUp: String {
//        if self <= 9 {
//            return "0\(self)"
//        }
//        else {
//            return "\(self)"
//        }
        return "\(self)"
    }
    
    var currency: String {
        return Currency.formatter.string(for: self) ?? ""
    }
    func stringFromInterval(interval:Int,stringFormat:String = "dd/MM/yyyy") -> String {
        let date = self.dateWithInterval(interval: interval)
        return date.toString(withFormat: stringFormat)
    }
    func dateWithInterval(interval:Int) -> Date {
        return NSDate(timeIntervalSince1970: TimeInterval(interval)) as Date
    }
    func convertIntToTimeStamp(TimeStamp : Int = 0, formatDate : String = "dd/MM/yyyy") -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(TimeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date as Date)
    }
    
    func toTimestampString(formatString: String = "dd/MM/yyyy HH:mm") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: date)
    }
    
    func convertTimeStamp(formatDate : String = "dd/MM/yyyy") -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date as Date)
    }
    
    func timeFormatted_secret() -> String {
        let seconds: Int = self % 60
        let minutes: Int = (self / 60) % 60
        let hours: Int = self / 3600
        if hours > 0{
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

