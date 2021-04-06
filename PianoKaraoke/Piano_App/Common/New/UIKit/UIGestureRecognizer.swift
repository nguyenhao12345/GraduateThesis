//
//  UIGestureRecognizer.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UIGestureRecognizer {

    /// SwifterSwift: Remove Gesture Recognizer from its view.
    func removeFromView() {
        view?.removeGestureRecognizer(self)
    }

}
#endif
