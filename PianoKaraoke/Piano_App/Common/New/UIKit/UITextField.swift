//
//  UITextField.swift
//  Azibai
//
//  Created by macmall on 6/14/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import UIKit
private var AssociatedObjectHandle: UInt8 = 0
extension UITextField{
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    open override func draw(_ rect: CGRect) {
//        autocorrectionType = .no
//        addDoneButtonOnKeyboard()
    }

    var userInfo : [String:String]{
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? [String:String] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
