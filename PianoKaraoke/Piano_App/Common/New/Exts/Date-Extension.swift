//
//  Date-Extension.swift
//  azibai
//
//  Created by  Hoan  vu on 5/15/17.
//  Copyright © 2017 azibai. All rights reserved.
//

import Foundation


extension Date {
    func getDayOfMonth() -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        let dayOfMonth = components.day
        return dayOfMonth
    }
    var dateToInt: Int {
        let timeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    var dateToDouble: Double {
        let timeInterval = self.timeIntervalSince1970
        return Double(timeInterval)
    }
    
    static func convertTimeStamp(TimeStamp : Int = 0, formatDate : String = "dd/MM/yyyy") -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(TimeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date as Date)
    }
    
    static func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    static func timeAgoSinceDate(TimeStamp: Int) -> String {
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(TimeStamp))
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if components.year! < 1, components.month! < 1, components.weekOfYear! < 1, components.day! < 1 {
            if components.hour! >= 2 {
                return String(format: "%d giờ trước".localized, components.hour!)
            } else if components.hour! >= 1 {
                return "1 giờ trước".localized
            } else if components.minute! >= 2 {
                return String(format: "%d phút trước".localized, components.minute!)
            } else if components.minute! >= 1 {
                return "1 phút trước".localized
            } else if components.second! >= 3 {
                return String(format: "%d giây trước".localized, components.second!)
            } else {
                return "Ngay bây giờ".localized
            }
        } else {
            return Date.convertTimeStamp(TimeStamp: TimeStamp, formatDate: "dd/MM/yyyy")
        }
        
    }
    
    static func DayAgoSinceDate(TimeStamp: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(TimeStamp))
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if components.day! < 1 {
                return "Hôm nay".localized
        } else {
            return Date.convertTimeStamp(TimeStamp: TimeStamp, formatDate: "EEEE, dd/MM/yyyy")
        }
    }
}
