//
//  ExtensionUITextField.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/20/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
extension UITextField {
    func changeColor(placeholder: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
