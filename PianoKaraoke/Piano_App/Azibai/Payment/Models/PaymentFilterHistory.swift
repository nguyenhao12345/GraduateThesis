//
//  PaymentFilterHistory.swift
//  Piano_App
//
//  Created by Azibai on 02/06/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Foundation

protocol PaymentFilterField {
    func getDatas() -> [PaymentFilterField]
    func getDates() -> (String, String)
    var key: Int? { get }
    var name: String { get }
}

class PaymentFilterHistory {
    var field1: PaymentFilterHistory.Field1Option
    var time: PaymentFilterHistory.TimeOption
    var minMoney: Double
    var maxMoney: Double
    
    
    func getParam() -> [String: Any] {
        return ["from": time.getDates().0,
                "to": time.getDates().1,
                "is_withdrawal": field1.key ?? -1,
                "amount_minimum": minMoney,
                "amount_maximum": maxMoney
        ]
    }
    
    init(field1: PaymentFilterHistory.Field1Option,
         time: PaymentFilterHistory.TimeOption,
         minMoney: Double,
         maxMoney: Double) {
        self.field1 = field1
        self.time = time
        self.minMoney = minMoney
        self.maxMoney = maxMoney
    }
}

extension PaymentFilterHistory {
    
    enum Field1Option: Int, PaymentFilterField {
        
        var key: Int? {
            return self.rawValue
        }
        
        func getDates() -> (String, String) {
            return ("", "")
        }
        
        case All = -1
        case MoneyIn = 0
        case MoneyOut = 1
        
        var name: String {
            switch self {
            case .All:
                return "Tất cả"
            case .MoneyIn:
                return "Tiền vào"
            case .MoneyOut:
                return "Tiền ra"
            }
        }
        
        func getDatas() -> [PaymentFilterField] {
            return [Field1Option.All, Field1Option.MoneyIn, Field1Option.MoneyOut]
        }
    }
}

extension PaymentFilterHistory {
    enum TimeOption: PaymentFilterField {
        var key: Int? { return nil }
        
        func getDates() -> (String, String) {
            switch self {
            case .ThirtyDay:
                let last30Days = Date.getDates(forLastNDays: 30)
                return (last30Days.last ?? "", last30Days.first ?? "")
            case .SevenDay:
                let last7Days = Date.getDates(forLastNDays: 7)
                return (last7Days.last ?? "", last7Days.first ?? "")
            case .Some(let start, let end):
               return (start, end)
            }
        }
        
        case ThirtyDay
        case SevenDay
        case Some(startDate: String, endDate: String)
        
        func getDatas() -> [PaymentFilterField] {
            return [TimeOption.ThirtyDay, TimeOption.SevenDay, TimeOption.Some(startDate: "", endDate: "")]
        }
        
        var name: String {
            switch self {
            case .ThirtyDay:
                return "30 ngày gần nhất"
            case .SevenDay:
                return "7 ngày gần nhất"
            case .Some:
                return "Khoảng thời gian"
            }
        }
    }
}
