//
//  ExtensionNavigation.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/16/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func setUpUINaviationItem() {
        self.navigationBar.barStyle = .blackOpaque
        self.navigationBar.tintColor = UIColor.white
//        self.navigationBar.isHidden = true
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 20)!,NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: "FFFFFF", alpha: 1)]
        self.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: "17182C", alpha: 1)
    }
}
