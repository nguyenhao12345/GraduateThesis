//
//  extendfile.swift
//  azibai
//
//  Created by Mac on 4/26/17.
//  Copyright © 2017 azibai. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import AudioToolbox

extension UITextField {
    
    /*** set icon of 15x15 with left padding of 8px ***/
    func setLeftIcon(_ icon: UIImage) {
        let paddingL = 8
        let paddingR = 8
        let iconSize = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize + paddingL + paddingR, height: iconSize))
        let iconView  = UIImageView(frame: CGRect(x: paddingL, y: 0, width: iconSize, height: iconSize))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }
    
    func setLeftPadding() {
        let paddingL = 10
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: paddingL, height: 0))
        leftView = outerView
        leftViewMode = .always
    }
    
}

extension UILabel {
    // set auto font size for font label
    func autoFontSize(_ fontName: String? = nil, size: Double){
        let f:Double = size / 667.0
        let fontSize = Const.heightScreen * CGFloat(f)
        if let fontName = fontName {
            self.font =  UIFont(name: fontName, size: fontSize)
        } else {
            self.font =  UIFont(name: "Helvetica Neue-Medium", size: fontSize)
        }
    }
    
    func changeTextColorOfCertainText(mainString: String, string_to_color: String) {
        let range = (mainString as NSString).range(of: string_to_color)
        
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.attributedText = attribute
    }
}

extension UIImage {
    var jpeg: Data? {
       return self.jpegData(compressionQuality: 1)
    }

    func circularImage(border: Bool) -> UIImage {
        let newSize = size 
        
        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        
        context!.setBlendMode(.copy)
        context!.setFillColor(UIColor.clear.cgColor)
        
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()
        
        if border{
            let borderRect = CGRect(origin: CGPoint.zero, size: size).insetBy(dx: size.width / 2, dy: size.width / 2)
            context!.setStrokeColor(UIColor.white.cgColor)
            context!.setLineWidth(6)
            context?.stroke(borderRect)
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    func squared() -> UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
    
    
    @IBDesignable class CircularImageView: UIImageView {
        override var image: UIImage? {
            didSet {
                super.image = image?.circularImage(border: false)
            }
        }
        
    }
    @IBDesignable class CircularImageButton: UIButton {
        override func setImage(_ image: UIImage?, for state: UIControl.State) {
            let circularImage = image?.circularImage(border: false)
            super.setImage(circularImage, for: state)
        }
    }
}

extension NSArray {
    func removeObjectValue(object: AnyObject) -> NSArray{
        let indexOfA = self.index(of: object)
        if indexOfA >= 0
        {
            let arr = self.mutableCopy() as? NSMutableArray
            arr?.removeObject(at: indexOfA)
            return arr?.copy() as! NSArray
        }
        return self
    }
}

extension Array where Element: Equatable {
    
    mutating func removeEqualItems(item: Element) {
        self = self.filter { (currentItem: Element) -> Bool in
            return currentItem != item
        }
    }
    
}

//extension UINavigationController {
//    
//    private func doAfterAnimatingTransition(animated: Bool, completion: @escaping (() -> Void)) {
//        if let coordinator = transitionCoordinator, animated {
//            coordinator.animate(alongsideTransition: nil, completion: { _ in
//                completion()
//            })
//        } else {
//            DispatchQueue.main.async {
//                completion()
//            }
//        }
//    }
//    
//    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping (() ->     Void)) {
//        pushViewController(viewController, animated: animated)
//        doAfterAnimatingTransition(animated: animated, completion: completion)
//    }
//    
//    func popViewController(animated: Bool, completion: @escaping (() -> Void)) {
//        popViewController(animated: animated)
//        doAfterAnimatingTransition(animated: animated, completion: completion)
//    }
//    
//    func popToRootViewController(animated: Bool, completion: @escaping (() -> Void)) {
//        popToRootViewController(animated: animated)
//        doAfterAnimatingTransition(animated: animated, completion: completion)
//    }
//}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}

extension NSMutableAttributedString {
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
