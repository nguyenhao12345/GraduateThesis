//
//  UINavigationBar.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UINavigationBar {

    /// SwifterSwift: Set Navigation Bar title, title color and font.
    ///
    /// - Parameters:
    ///   - font: title font
    ///   - color: title text color (default is .black).
    func setTitleFont(_ font: UIFont, color: UIColor = .black) {
//        var attrs = [NSAttributedString.Key: Any]()
//        attrs[.font] = font
//        attrs[.foregroundColor] = color
//        titleTextAttributes = attrs
    }

    /// SwifterSwift: Make navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor = .white, withShadow shadow: Bool = false, _backgroundColor: UIColor = .white) {
        isTranslucent = true
        backgroundColor = _backgroundColor
        barTintColor = .clear
        setBackgroundImage(UIImage(), for: .default)
        tintColor = tint
        titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: tint])
        if !shadow {
            shadowImage = UIImage()
        }
//        else {
//            shadowImage = UIImage(named: "navigation_button_shadow")
//        }
    }

    /// SwifterSwift: Set navigationBar background and text colors
    ///
    /// - Parameters:
    ///   - background: backgound color
    ///   - text: text color
    func setColors(background: UIColor, text: UIColor) {
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
        setBackgroundImage(UIImage(), for: .default)
        tintColor = text
        titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: text])
    }

}
#endif

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
