//
//  TimeInterval.swift
//  Azibai
//
//  Created by Tran Quoc Loc on 12/28/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    private var intValue: NSInteger {
        return NSInteger(self)
    }
    
    public var day: Int {
        return (intValue / 3600) / 24
    }
    
    public var dayString: String {
        return ((day < 10) ? "0" : "") + day.string
    }
    
    public var hour: Int {
        return (intValue / 3600) % 24
    }
    
    public var hourString: String {
        return ((hour < 10) ? "0" : "") + hour.string
    }
    
    public var minute: Int {
        return (intValue / 60) % 60
    }
    
    public var minuteString: String {
        return ((minute < 10) ? "0" : "") + minute.string
    }
    
    public var second: Int {
        return intValue % 60
    }
    
    public var secondString: String {
        return ((second < 10) ? "0" : "") + second.string
    }
}
