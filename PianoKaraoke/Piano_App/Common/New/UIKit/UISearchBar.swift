//
//  UISearchBar.swift
//  Azibai
//
//  Created by macmall on 3/11/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import UIKit

extension UISearchBar{
    
    func addNavigationBar(){
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        for myView in self.subviews  {
            for mySubView in myView.subviews  {
                if let textField = mySubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.origin.y = -2 //(set your height)
                    bounds.origin.x = 4
                    textField.bounds = bounds
                    textField.borderStyle = UITextField.BorderStyle.none
                }
            }
        }
    }
    func change(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            
            if let textField = view as? UITextField {
                textField.font = textFont
            }
        }
    }
    
}
