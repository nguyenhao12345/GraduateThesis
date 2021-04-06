//
//  UINavigationController.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UINavigationController {

    /// SwifterSwift: Pop ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition (default is true).
    ///   - completion: optional completion handler (default is nil).
    func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        #if Azibai
        CustomAVPlayer.globalPlayer?.deactive()
        #else
        #endif
        popViewController(animated: animated)
        CATransaction.commit()
    }

    /// SwifterSwift: Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    ///   - completion: optional completion handler (default is nil).
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        #if Azibai
        CustomAVPlayer.globalPlayer?.deactive()
        #else
        #endif
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    /// Push new Screen
    /// - Parameters:
    ///   - viewController:
    ///   - withNavigation:
    func push(_ viewController: UIViewController, animation: Bool) {
        viewController.modalTransitionStyle = .flipHorizontal
        viewController.modalPresentationStyle = .fullScreen
        #if Azibai
        CustomAVPlayer.globalPlayer?.deactive()
        #else
        #endif
        pushViewController(viewController, animated: animation)
    }
    
    func popToRootViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        #if Azibai
        CustomAVPlayer.globalPlayer?.deactive()
        #else
        #endif
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }

    /// SwifterSwift: Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor = .white, withShadow shadow: Bool = false, backgroundColor: UIColor = .white) {
        navigationBar.makeTransparent(withTint: tint, withShadow: shadow, _backgroundColor: backgroundColor)
    }
    
    func pushViewController(_ viewController: UIViewController, withNavi: Bool, withTabbar: Bool, completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        #if Azibai
        CustomAVPlayer.globalPlayer?.deactive()
        #else
        #endif
        pushViewController(viewController, animated: true)
        CATransaction.commit()
        isNavigationBarHidden = !withNavi
        tabBarController?.tabBar.isHidden = !withTabbar
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
       return topViewController?.preferredStatusBarStyle ?? .default
    }
}
#endif
