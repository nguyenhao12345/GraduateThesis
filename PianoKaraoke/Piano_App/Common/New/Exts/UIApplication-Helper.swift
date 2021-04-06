//
//  UIApplication-Helper.swift
//  MobileApp
//
//  Created by HoanVu on 11/16/16.
//  Copyright © 2016 Universal IT Solution. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func sd_loadImageUrl(url:URL?, withDefault: String) {
        if url != nil {
            self.sd_setImage(with: url, placeholderImage: UIImage(named: withDefault))
        }
    }
    
    func sd_loadImageUrl(url:URL?) {
        if url != nil {
            self.sd_setImage(with: url, placeholderImage: UIImage(named: "ImageDefault"))
        }
    }
    
    func loadImageURL(url:URL?, completionBlock:@escaping (_ image:UIImage?) -> (Void)) {
        
        if url != nil {
            self.sd_setImage(with: url) { (image, error, type, url) in
                completionBlock(image)
            }
        }else {
            completionBlock(nil)
        }
        
    }
}


extension UIApplication {
    
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    func rootNavigationController() -> UINavigationController? {
        
        if let nv = self.keyWindow?.rootViewController as? UINavigationController {
            return nv
        }
        return nil
    }

    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.lastObject as? String,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }

        return icon
    }
}


extension UIViewController {
    
    func embedNVController() -> UINavigationController {
        return UINavigationController.init(rootViewController: self)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.autoDismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func autoDismissKeyboard() {
        view.endEditing(true)
    }
}
