//
//  UIApplication.swift
//  Azibai
//
//  Created by Azi IOS on 1/2/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import UIKit

extension UIApplication {
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for window in windows {
            window.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    var statusBarView: UIView?{
        if #available(iOS 13.0, *) {
            let tag = 79797979
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                var statusBarView = UIView(frame: statusBarFrame)
                if let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame {
                    statusBarView = UIView(frame: statusBarFrame)
                }
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                statusBarView.backgroundColor = .white
                return statusBarView
            }

        } else {
            //Below iOS13
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            } else {
                return nil
            }
        }
        
        
//        if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        } else {
//            return nil
//        }
    }
    
    func updateProcessView(index : Int,total : Int){
//        if let v = statusBarView?.viewWithTag(6789679){
//            v.removeFromSuperview()
//        }
//        if let statusBarView = statusBarView{
//            let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: statusBarView.height))
//            view.tag = 6789679
//            view.backgroundColor = stringToColor(stringColor: "FF1678")
//            view.frame.size.width = statusBarView.width * CGFloat(index) / CGFloat(total)
//            statusBarView.insertSubview(view, at: 0)
//        }
//        if let v = statusBarView?.viewWithTag(6789679){
//            v.removeFromSuperview()
//        }
//        if let statusBarView = statusBarView{
//            let view : UIView = UIView(frame: CGRect(x: 0, y: statusBarView.height - 2, width: 0, height: 2))
//            view.tag = 6789679
//            view.backgroundColor = stringToColor(stringColor: "FF1678")
//            view.frame.size.width = statusBarView.width * CGFloat(index) / CGFloat(total)
//            statusBarView.insertSubview(view, at: 0)
//        }
        
    }
    
    func doneProcessView(){
//        if let v = statusBarView?.viewWithTag(6789679){
//            v.removeFromSuperview()
//        }
    }
}

