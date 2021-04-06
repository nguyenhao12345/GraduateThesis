//
//  Localizable.swift
//  LocalizationApp
//
//  Created by Azi IOS on 11/7/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import UIKit

private let appleLanguagesKey = "AppleLanguages"

// MARK: Localizable
enum AppLanguage: String {
    
    case english = "en"
    case vietnamese = "vi"
    
    static var language: AppLanguage {
        get {
            if let languageCode = UserDefaults.standard.string(forKey: appleLanguagesKey),
                let language = AppLanguage(rawValue: languageCode) {
                return language
            } else {
                let preferredLanguage = NSLocale.preferredLanguages[0] as String
                let index = preferredLanguage.index(
                    preferredLanguage.startIndex,
                    offsetBy: 2
                )
                guard let localization = AppLanguage(
                    rawValue: String(preferredLanguage[..<index])
                    ) else {
                        return AppLanguage.english
                }
                
                return localization
            }
        }
        set {
            guard language != newValue else {
                return
            }
            
            UserDefaults.standard.set([newValue.rawValue], forKey: appleLanguagesKey)
            UserDefaults.standard.synchronize()
        }
    }
}


extension String {
    
    var localized: String {
        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
}

extension Bundle {
    
    static var localizedBundle: Bundle {
        let languageCode = AppLanguage.language.rawValue
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)!
    }
}

// MARK: XIBLocalizable
public protocol XIBLocalizable {
    var localizedKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var localizedKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable public var localizedKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

extension UINavigationItem: XIBLocalizable {
    @IBInspectable public var localizedKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

extension UIBarItem: XIBLocalizable { // Localizes UIBarButtonItem and UITabBarItem
    @IBInspectable public var localizedKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

// MARK: Special protocol to localize multiple texts in the same control
public protocol XIBMultiLocalizable {
    var localizedKeys: String? { get set }
}

extension UISegmentedControl: XIBMultiLocalizable {
    @IBInspectable public var localizedKeys: String? {
        get { return nil }
        set(keys) {
            guard let keys = keys?.components(separatedBy: ","), !keys.isEmpty else { return }
            for (index, title) in keys.enumerated() {
                setTitle(title.localized, forSegmentAt: index)
            }
        }
    }
}

// MARK: Special protocol to localizaze UITextField's placeholder
public protocol UITextFieldXIBLocalizable {
    var placeholderLocalizedKey: String? { get set }
}

extension UITextField: UITextFieldXIBLocalizable {
    @IBInspectable public var placeholderLocalizedKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}
