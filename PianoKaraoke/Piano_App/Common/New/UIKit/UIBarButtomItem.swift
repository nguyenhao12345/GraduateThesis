//
//  UIBarButtomItem.swift
//  Azibai
//
//  Created by Macmall on 11/20/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}
