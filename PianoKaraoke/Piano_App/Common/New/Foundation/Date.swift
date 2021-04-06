//
//  Date.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import Foundation

enum CountdownResponse {
    case isFinished
    case result(time: String)
}

extension Date {
    
    init?(dateString:String, format: String = "dd/MM/yyyy", timeZone: TimeZone? = TimeZone(identifier:"GMT")) {
        if dateString.isEmpty {
            return nil
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale.current
            formatter.timeZone = timeZone
            if let d = formatter.date(from: dateString), d.timeIntervalSince1970 > 0 {
                self = d
            }
            else {
                return nil
            }
        }
    }
    
    func toString(withFormat format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    static func >=(a: Date, b: Date) -> Bool {
        return a.compare(b) == .orderedDescending || a.compare(b) == .orderedSame
    }
    
    static func >(a: Date, b: Date) -> Bool {
        return a.compare(b) == .orderedDescending
    }
    
    static func <=(a: Date, b: Date) -> Bool {
        return a.compare(b) == .orderedAscending || a.compare(b) == .orderedSame
    }
    
    static func <(a: Date, b: Date) -> Bool {
        return a.compare(b) == .orderedAscending
    }
    

    
    func daysBetweenDate( endDate: Date) -> Int{
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: endDate)
        
        let componentsDay = calendar.dateComponents([.day], from: date1, to: date2)
        
        return componentsDay.day ?? 0
    }
    
    
    func getNextDay(day : Int) -> Date{
        
        return Calendar.current.date(byAdding: .day, value: day, to: Date())!
    }
    
    private static let dateComponentFormatter: DateComponentsFormatter = {
        var formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .short
        return formatter
    }()
    
    func countDownTime(listingDate : Date) -> DateComponents{
        let now = Date()
        let calendar = Calendar.current
        return calendar.dateComponents([.hour, .minute, .second], from: now, to: listingDate)
    }
    
}

extension Date {
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    mutating func changeDays(by days: Int) {
          self = Calendar.current.date(byAdding: .day, value: days, to: Date())!
          
      }
      
      mutating func changeMonths(by months: Int) {
          
          self = Calendar.current.date(byAdding: .month, value: months, to: Date())!
      }
}
