//
//  ExtensionUISearchBar.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/16/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

extension UISearchBar {
    func changeBackgroundColorTextFiled(color: UIColor) {
        for view in self.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as? UITextField ?? UITextField()
                    textField.backgroundColor = color
                }
            }
        }
    }
    func changeBackgroundUISearchBar() {
        for subView in self.subviews {
            for view in subView.subviews {
                if view.isKind(of: NSClassFromString("UINavigationButton")!) {
                    let cancelButton = view as! UIButton
                    cancelButton.setTitleColor(UIColor.hexStringToUIColor(hex: "FFFFFF", alpha: 1), for: .normal)
                    cancelButton.setTitle("Huỷ", for: .normal)
                }
                if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                    let imageView = view as! UIImageView
                    //                    imageView.removeFromSuperview()
                    imageView.backgroundColor = .red
                }
            }
        }
    }
}
