//
//  UIView-Helper.swift
//  MobileApp
//
//  Created by  Hoan  vu on 11/15/16.
//  Copyright © 2016 Universal IT Solution. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }

    public func addSubViewAndBoundMaskPin(_ view: UIView){
        self.addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBInspectable
    public var bottomLineColor: UIColor? {
        get {
            return UIColor.white;
        }
        
        set {
            let line = UIView.init(frame: CGRect(x: 0, y: self.bounds.size.height - 0.5, width: self.bounds.size.width, height: 0.5))
            line.backgroundColor = newValue
            self.addSubview(line)
            line.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        }
    }
    
    @IBInspectable
    public var topLineColor: UIColor? {
        get {
            return UIColor.white
        }
        set {
            let line = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 0.5))
            line.backgroundColor = newValue
            self.addSubview(line)
            line.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        }
    }
    
    @IBInspectable
    public var leftLineColor: UIColor? {
        get {
            return UIColor.white
        }
        set {
            let line = UIView.init(frame: CGRect(x: 0, y: 0, width: 0.5, height: self.bounds.size.height))
            line.backgroundColor = newValue
            self.addSubview(line)
            line.autoresizingMask = [.flexibleHeight]
        }
    }
    
    @IBInspectable
    public var rightLineColor: UIColor? {
        get {
            return UIColor.white
        }
        set {
            let line = UIView.init(frame: CGRect(x: self.bounds.size.width - 0.5, y: 0, width: 0.5, height: self.bounds.size.height))
            line.backgroundColor = newValue
            self.addSubview(line)
            line.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        }
    }
    override open func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
    }
    
    var myViewController:UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let parentView = parentResponder as? UIViewController {
                return parentView
            }
        }
        return nil
    }
    
    // add constraint for [view] with format
    func addConstraintWithFormat(_ format: String, views: UIView...) {
        var dictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            dictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: dictionary))
    }
    
    
    
//MARK: ================ frame
    var originX:CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var originY:CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    
    
    var origin:CGPoint {
        set {
            self.frame.origin = newValue
        }
        get {
            return self.frame.origin
        }
    }
    

    
    
    
    
//MARK: ============= layer
    
    func createBorderColor(color:UIColor) {
        self.layer.borderColor = color.cgColor

    }
    
    
    func createBorderWidth(width:CGFloat) {
        self.layer.borderWidth = width;
    }
    
    
    
    func createCricleRadius() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
