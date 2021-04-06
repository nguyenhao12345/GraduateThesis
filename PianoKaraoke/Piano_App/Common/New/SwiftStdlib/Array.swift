//
//  Array.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeIf(_ closure:((Element) -> Bool)) {
        for i in (0..<self.count).reversed() {
            
            if closure(self[i]) {
                
                self.remove(at: i)
            }
        }
    }
    
    func random() -> Element {
        let count = self.count
        let randomIndex: Int = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
