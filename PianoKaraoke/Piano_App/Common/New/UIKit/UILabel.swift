//
//  UILabel.swift
//  Azibai
//
//  Created by Azi IOS on 12/10/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import UIKit

public struct RangedAttributes {
    
    let attributes: [NSAttributedString.Key: Any]
    let range: NSRange
    
    public init(_ attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        self.attributes = attributes
        self.range = range
    }
}

public protocol ChangableFont: AnyObject {
    var text: String? { get set }
    var attributedText: NSAttributedString? { get set }
    var rangedAttributes: [RangedAttributes] { get }
    func getFont() -> UIFont?
    func changeFont(ofText text: String, with font: UIFont)
    func changeFont(inRange range: NSRange, with font: UIFont)
    func changeTextColor(ofText text: String, with color: UIColor)
    func changeTextColor(inRange range: NSRange, with color: UIColor)
}

public extension ChangableFont {
    
    var rangedAttributes: [RangedAttributes] {
        guard let attributedText = attributedText else {
            return []
        }
        var rangedAttributes: [RangedAttributes] = []
        let fullRange = NSRange(
            location: 0,
            length: attributedText.string.count
        )
        attributedText.enumerateAttributes(
            in: fullRange,
            options: []
        ) { (attributes, range, stop) in
            guard range != fullRange, !attributes.isEmpty else { return }
            rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        }
        return rangedAttributes
    }
    
    func changeFont(ofText text: String, with font: UIFont) {
//        guard let range = (self.attributedText?.string ?? self.text)?.range(of: text) else { return }
//        changeFont(inRange: range, with: font)
    }
    
    func changeFont(inRange range: NSRange, with font: UIFont) {
        add(attributes: [.font: font], inRange: range)
    }
    
    func changeTextColor(ofText text: String, with color: UIColor) {
//        guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
//        changeTextColor(inRange: range, with: color)
    }
    
    func changeTextColor(inRange range: NSRange, with color: UIColor) {
        add(attributes: [.foregroundColor: color], inRange: range)
    }
    
    private func add(attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        guard !attributes.isEmpty else { return }
        
        var rangedAttributes: [RangedAttributes] = self.rangedAttributes
        
        var attributedString: NSMutableAttributedString
        
        if let attributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else if let text = text {
            attributedString = NSMutableAttributedString(string: text)
        } else {
            return
        }
        
        rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        
        rangedAttributes.forEach { (rangedAttributes) in
            attributedString.addAttributes(
                rangedAttributes.attributes,
                range: rangedAttributes.range
            )
        }
        
        attributedText = attributedString
    }
}

extension UILabel: ChangableFont {
    
    public func getFont() -> UIFont? {
        return font
    }
    
    func convertPlayTime(time : Float64){

        let minute = Int(time/60)
        let second = Int(time) - minute*60
        
        if minute > 10 && second > 10{
            self.text = "\(minute):\(second)"
        }
        else if minute < 10 && second > 10{
            self.text = "0\(minute):\(second)"
        }
        else if minute > 10 && second < 10{
            self.text = "\(minute):0\(second)"
        }
        else if minute < 10 && second < 10{
            self.text = "0\(minute):0\(second)"
        }
        else{
            self.text = "--:--"
        }
    }
}

extension UITextField: ChangableFont {
    
    public func getFont() -> UIFont? {
        return font
    }
}

extension UILabel {
    
    func calculateMaxLines() -> Float {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil)
        let linesRoundedUp = Float(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
}

