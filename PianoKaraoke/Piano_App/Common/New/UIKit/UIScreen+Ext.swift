//
//  UIScreen.swift
//  Azibai
//
//  Created by Mac on 5/20/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import UIKit

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case phone
    case pad
}

struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let iPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    static let iPhone8 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let iPhone8Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let iPhoneXr = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPhoneXs = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 812.0
    static let iPhoneXsMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPad = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 1024.0
}

extension UIScreen {
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    var screenWidthScale: CGFloat {
        return UIScreen.main.bounds.size.width * UIScreen.main.scale
    }
    
    var screenHeightVisible: CGFloat {
        if screenHeight > 736 {
            return screenHeight - 88
        } else {
            return screenHeight - 64
        }
    }
}