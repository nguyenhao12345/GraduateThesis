//
//  GetFrameUIScreen.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 2/28/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import UIKit
class GetFramUIScreen {
    
    static let share = GetFramUIScreen()
    
    func getWitdhUIScreen() -> Float {
        return Float(UIScreen.main.bounds.size.width)
    }
    
    func getHeightUIScreen() -> Float  {
        return Float(UIScreen.main.bounds.size.height)
    }
    
}
