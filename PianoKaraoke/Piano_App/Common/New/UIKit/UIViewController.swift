//
//  UIViewController.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit
import PINRemoteImage


enum PinResultRequest {
    case image(imageData: Data, size: CGSize)
    case animatedImage(imageData: Data, size: CGSize)
}

//extension UIViewController: DismissTriggerUsable {
//    
//}
extension UIViewController: PINRemoteImageManagerAlternateRepresentationProvider {
    
    func pinDowloadImage(imageUrl: URL, completion: @escaping(PinResultRequest) -> ()) {
        let imageManager = PINRemoteImageManager.init(sessionConfiguration: nil, alternativeRepresentationProvider: self)
        imageManager.downloadImage(with: imageUrl) { (result : PINRemoteImageManagerResult) in
            
            guard let animatedData = result.alternativeRepresentation as? NSData, let animatedSize = PINGIFAnimatedImage(animatedImageData: animatedData as Data) else {
                if let data = result.image?.compressedData(quality: 1.0) {
                    completion(.image(imageData: data, size: result.image?.size ?? CGSize.zero))
                }
                
                return
            }
            completion(.animatedImage(imageData: animatedData as Data, size: CGSize(width: CGFloat(animatedSize.width), height: CGFloat(animatedSize.height))))
        }
    }
    
    public func alternateRepresentation(with data: Data!, options: PINRemoteImageManagerDownloadOptions = []) -> Any! {
        guard let nsdata = data as NSData? else {
            return nil
        }
        if nsdata.pin_isGIF() || nsdata.pin_isAnimatedGIF() {
            return data
        }
        return nil
    }
}

// MARK: - Properties
public extension UIViewController {

    /// SwifterSwift: Check if ViewController is onscreen and not hidden.
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return isViewLoaded && view.window != nil
    }

    
}

// MARK: - Methods
public extension UIViewController {

    /// SwifterSwift: Assign as listener to notification.
    ///
    /// - Parameters:
    ///   - name: notification name.
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    /// SwifterSwift: Unassign as listener to notification.
    ///
    /// - Parameter name: notification name.
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    /// SwifterSwift: Unassign as listener from all notifications.
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    /// SwifterSwift: Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    @discardableResult func showAlertCustomize(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController{
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Change font and color of title
        alertController.setTitlet(font: UIFont(name: "KoHo-SemiBold", size: 18), color: .black)
        
        // Change font and color of message
        alertController.setMessage(font: UIFont(name: "KoHo-Regular", size: 15), color: .black)
        
        // Change background color of UIAlertController
        alertController.setBackgroundColor(color: .white)
        
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK".localized)
        }
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        
        alertController.setTint(color: .black)
        
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    @discardableResult func showDialogBottom(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController{
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        // Change font and color of title
        alertController.setTitlet(font: .HelveticaNeueBold16, color: .defaultText)
        
        // Change font and color of message
        alertController.setMessage(font: .HelveticaNeueBold16, color: .defaultText)
        
        // Change background color of UIAlertController
//        alertController.setBackgroundColor(color: .white)
        
        let allButtons = buttonTitles ?? [String]()
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            //action.setValue(#imageLiteral(resourceName: "doccument"), forKey: "image")
//            action.setValue(CATextLayerAlignmentMode.center, forKey: "titleTextAlignment")
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        
        let action = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        //action.setValue(#imageLiteral(resourceName: "doccument"), forKey: "image")
//        action.setValue(CATextLayerAlignmentMode.center, forKey: "titleTextAlignment")
        alertController.addAction(action)
        
        alertController.setTint(color: .systemBlue)
        
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = UIScreen.main.bounds
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    @discardableResult func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }

    /// SwifterSwift: Helper method to add a UIViewController as a childViewController.
    ///
    /// - Parameters:
    ///   - child: the view controller to add as a child
    ///   - containerView: the containerView for the child viewcontroller's root view.
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        child.view.frame = containerView.bounds
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// SwifterSwift: Helper method to remove a UIViewController from its parent.
    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    /// Loc: Show modal
    /// Present new Screen
    /// - Parameters:
    ///   - viewController:
    ///   - withNavigation:  Root new screen
    func present(_ viewController: UIViewController, withNavigation: Bool, isSetupDismissable: Bool = false) {
        if withNavigation {
            let nav = BaseNavigationController(rootViewController: viewController)
            nav.previousViewController = self
//            nav.setup(self)
            nav.modalTransitionStyle = .crossDissolve
            nav.modalPresentationStyle = .fullScreen
            #if Azibai
            CustomAVPlayer.globalPlayer?.deactive()
            #else
            #endif
            present(nav, animated: true, completion: nil)
        }
        else {
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            #if Azibai
            CustomAVPlayer.globalPlayer?.deactive()
            #else
            #endif
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func dismiss(_ completion: (() -> Void)? = nil) {
        #if Azibai
        CustomAVPlayer.globalPlayer?.pause()
        #else
        #endif
        dismiss(animated: true, completion: completion)
    }
    
    func dismissExt(animated: Bool = true, completion: (() -> Void)? = nil) {
        #if Azibai
        CustomAVPlayer.globalPlayer?.pause()
        #else
        #endif
        dismiss(animated: animated, completion: completion)
    }
    
    func dismiss(toViewController withName: String,animated: Bool = true, _ completion: (() -> Void)? = nil) {
        #if Azibai
        CustomAVPlayer.globalPlayer?.pause()
        #else
        #endif
        guard let vc = self.presentingViewController else { return }
        self.dismiss(form: vc, to: withName, animated: animated, completion)
    }
    
    
    private func dismiss(form viewController: UIViewController, to vcNAme: String, animated: Bool, _ completion: (() -> Void)? = nil) {
        guard let vc = viewController.presentingViewController else { return }
        if vc.classNameString == vcNAme {
             vc.dismiss(animated: animated, completion: completion)
            return
        } else {
            dismiss(form: vc, to: vcNAme,animated: animated, completion)
        }
    }
    
    func presentAsAlert(_ viewController: UIViewController) {
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        present(viewController, animated: true, completion: nil)
    }
    
    func back(animated: Bool = false, completion: (() -> Void)? = nil) {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated, completion)
        }
        else {
            dismiss(completion)
        }
    }
    
    var isHiddenNaviStatus: Bool? {
        return navigationController?.isNavigationBarHidden
    }
    
    var isHiddenTabbarStatus: Bool? {
        return navigationController?.tabBarController?.tabBar.isHidden
    }
    
    func setTabbarHidden(isHidden: Bool?) {
        navigationController?.tabBarController?.tabBar.isHidden = isHidden ?? true
        navigationController?.tabBarController?.tabBar.isTranslucent = isHidden ?? true
    }
    
    func setNavigationHidden(isHidden: Bool?, animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(isHidden ?? true, animated: animated)
    }
}

// MARK: - Instantiate
public extension UIViewController {
    
    /// Loc: Khởi tạo view controller từ storyboard và identifier trong storyboard đó
    ///
    /// - Parameters:
    ///   - storyboard: tên storyboard, bằng nil nếu tên storyboard trùng tên class
    ///   - identifier: identifier trong storyboard, bằng nil nếu identifier trùng tên class
    class func instantiate(storyboard: String? = nil, identifier: String? = nil) -> Self
    {
        return _instantiate(storyboard: storyboard, identifier: identifier)
    }
    
    fileprivate class func _instantiate<T: UIViewController>(storyboard: String?, identifier: String?) -> T {
        let _storyboard = (storyboard != nil) ? storyboard! : String(describing: self)
        let _identifier = (identifier != nil) ? identifier! : String(describing: self)
        let storyboard = UIStoryboard(name: _storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: _identifier) as! T
        return controller
    }
}

// MARK: - Instantiate
public extension UIViewController {
    var previousVC:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers, controllersOnNavStack.count >= 2 {
            let n = controllersOnNavStack.count
            return controllersOnNavStack[n - 2]
        }
        return nil
    }
}

public extension UIViewController {
    // hieu ung rung view
    func shakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
}

extension UIViewController{
    func getCurrentViewController() -> UIViewController? {
        
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            
            return navigationController.visibleViewController
        }
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
//            childContaining(<#T##source: UIStoryboardUnwindSegueSource##UIStoryboardUnwindSegueSource#>)
            while (currentController.presentedViewController != nil) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    func getNavigationController() -> UINavigationController? {
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            
            return navigationController as? UINavigationController
        }
        return nil
    }
}


#endif
