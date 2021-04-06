//
//  Bool.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import Foundation

public extension Bool {
    
    /// SwifterSwift: Return 1 if true, or 0 if false.
    ///
    ///        false.int -> 0
    ///        true.int -> 1
    ///
    var int: Int {
        return self ? 1 : 0
    }
    
    /// SwifterSwift: Return "true" if true, or "false" if false.
    ///
    ///        false.string -> "false"
    ///        true.string -> "true"
    ///
    var string: String {
        return description
    }
    
}
