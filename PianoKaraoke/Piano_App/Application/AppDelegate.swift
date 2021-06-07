//
//  AppDelegate.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 10/13/18.
//  Copyright © 2018 com.nguyenhieu.demo. All rights reserved.
//


import UIKit
import Firebase
import FBSDKCoreKit
import YoutubeKit
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var shouldRotate: Bool = false
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if shouldRotate {
            return .landscapeRight
        } else {
            return .portrait
        }
    }
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func setUpScreenNavigation() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = AppAccount.shared.getUserLogin() {
//            let vc = TabbarViewController()
            let vc = ManagerPaymentViewController()
//            vc.configSelect(type: .History)
//            let vc = EditRecordViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        } else {
            let vc = AuthenticateViewController()
//            let vc = ManagerPaymentViewController()
//            let vc = EditRecordViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        
//        AppColor.shared.colorBackGround.subscribe(onNext: { (hex) in
//            UserDefaults.standard.set(hex, forKey: "colorBackGround")
//            UIView.animate(withDuration: 0.7) {
//                UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
//            }
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RealmHelper.shared.configure()

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemImage = UIImage(named: "arrow_down_gray")
        
        YoutubeKit.shared.setAPIKey(AppAccount.shared.getUserLogin()?.keyYoutube ?? "")

        YoutubeKit.shared.setAccessToken("YOUR_ACCESS_TOKEN")

        setUpScreenNavigation()

        return true
        
       
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        print("AppDelegate shouldRestoreApplicationState")
        if #available(iOS 13, *) {
            return false
        } else {
            return true
        }
    }
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        print("AppDelegate shouldSaveApplicationState")
        if #available(iOS 13, *) {
            return false
        } else {
            return true
        }
    }
    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        if #available(iOS 13, *) {

        } else {
            print("AppDelegate viewControllerWithRestorationIdentifierPath")

            // If this is for the nav controller, restore it and set it as the window's root
            if identifierComponents.first == "RootNC" {
                let nc = UINavigationController()
                nc.restorationIdentifier = "RootNC"
                self.window?.rootViewController = nc

                return nc
            }
        }
        return nil
    }

    private func customBackButtonNavigation() {
        let yourBackImage = UIImage(named: "backBtn")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance()?.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app,open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


let keyAPIYoube = ["AIzaSyAHNKxx1sO5TncigKXZosIGe0JawzlyKho", "AIzaSyBHlgJLrt0E1wAkCc0zi-rvhG66sW6fbIA",
           "AIzaSyAZQJLPNXJn8zXgenrTP5qpSn2zlTiyJAA",
           "AIzaSyDm4OOro9OsSxnQ8zf8KdUXhPnHkZtkv84"
]
var currentKeyAPIYoube = "AIzaSyAHNKxx1sO5TncigKXZosIGe0JawzlyKho"


