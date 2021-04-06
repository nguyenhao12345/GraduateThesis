//
//  ExtensionUIViewController.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/20/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
extension UIViewController {
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    func showAlertHaveCancel(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            UserDefaults.standard.removeObject(forKey: "UID")
//            ServiceFacebook.share.login.logOut()
            ServiceFacebook.share.logOut()
            let a = "a"
            print(Int(a)! )
        })
        let cancel = UIAlertAction(title: "Huỷ bỏ", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
