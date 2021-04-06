//
//  Float.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import UIKit

extension Float {
    var double: Double {
        return Double(self)
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
}

