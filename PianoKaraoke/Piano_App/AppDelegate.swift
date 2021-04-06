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
            let vc = TabbarViewController()
//            let vc = EditRecordViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        } else {
            let vc = AuthenticateViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        
        AppColor.shared.colorBackGround.subscribe(onNext: { (hex) in
            UIView.animate(withDuration: 0.7) {
                UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RealmHelper.shared.configure()

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemImage = UIImage(named: "arrow_down_gray")
//        IQKeyboardManager.shared.enableAutoToolbar = false
        
//        setUpScreenNavigation()
        
        YoutubeKit.shared.setAPIKey(currentKeyAPIYoube)

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

import RxSwift
import RxCocoa

class NewsFeedObserver: NSObject {
    static let shared = NewsFeedObserver()
    var newsFeeds: BehaviorRelay<NewsFeedModel?> = BehaviorRelay(value: nil)
    var comment: BehaviorRelay<CommentModel?> = BehaviorRelay(value: nil)

//    func subscribe(newsFeeds: NewsFeedModel?) {
//        newsFeeds.subscribe { (<#Event<NewsFeedModel?>#>) in
//            <#code#>
//        }
//    }
    
}

class AppColor: NSObject {
    static let shared = AppColor()
    var arrColor: [String] = ["CEA69D", "C6C96B" ,"70C3C7", "7BBFBC", "F28C8F"]
    var colorBackGround: BehaviorRelay<String> = BehaviorRelay(value: "F28C8F")
    
    func getColor() -> String {
        let object = arrColor.removeFirst()
        arrColor.append(object)
        return object
    }
    
//    override init() {
//        super.init()
//        AppColor.shared.colorBackGround.subscribe(onNext: { (hex) in
//            UIView.animate(withDuration: 0.7) {
//                UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
//            }
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
//
//    }
}


class AppRouter: NSObject {
    static let shared = AppRouter()
    
    func gotoUserWall(uidUSer: String, viewController: UIViewController) {
        let vc = UserWallViewController(uidUser: uidUSer)
        ManagerModernAVPlayer.shared.stop()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        vc.isHeroEnabled = true
        vc.addPansGesture = true
        vc.heroModalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
        viewController.present(vc, animated: true, completion: nil)
    }
    
    func gotoNewsFeedDetail(newsModel: NewsFeedModel?, viewController: UIViewController) {
        ManagerModernAVPlayer.shared.stop()
        if #available(iOS 13.0, *) {
            let vc = DetailNewsFeedViewController(newsModel: newsModel)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            vc.isHeroEnabled = true
            vc.addPansGesture = true
            vc.heroModalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))

            viewController.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
      }
    
    func gotoDetailMusic(id: String, viewController: UIViewController, frameAnimation: CGRect? = nil, viewAnimation: UIView? = nil, dataModel: DetailInfoSong? = nil) {
        ManagerModernAVPlayer.shared.stop()

        let vc = DetailSongViewController()
        vc.keyIdDetail = id
        vc.dataModel = dataModel
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        vc.isHeroEnabled = true
        vc.addPansGesture = true
        vc.heroModalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))

        
        if frameAnimation == nil {
            viewController.present(vc, animated: true, completion: nil)
            return
        }
        
        
        
        let currentFrameAnimation = CGRect(x: 12, y: UIApplication.shared.statusBarFrame.height, width: Const.widthScreens-24, height: Const.widthScreens*3/4)
        if let img = viewAnimation as? UIImageView {
            guard let window = UIApplication.shared.keyWindow else { return }
            let viewContainer = UIView(frame: window.frame)
            window.addSubview(viewContainer)
            
            viewController.view.isUserInteractionEnabled = false
            
            vc.imageMusic = img.image
            vc.oldFrameAnimation = frameAnimation
            vc.currentFrameAnimation = currentFrameAnimation
            let imageView = UIImageView(frame: frameAnimation ?? CGRect())
            imageView.image = img.image
            imageView.contentMode = .scaleAspectFill
            viewContainer.addSubview(imageView)
            viewAnimation?.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                imageView.frame = currentFrameAnimation
                imageView.cornerRadius = 12
                imageView.layoutIfNeeded() // add this
            }) { _ in
                viewController.present(vc, animated: false) {
                    viewController.view.isUserInteractionEnabled = true
                    viewAnimation?.alpha = 1
                    viewContainer.removeFromSuperview()
                }
            }

        }

        
    }
    
    func dismissAnimation(currentFrame: CGRect, oldFrame: CGRect, image: UIImage, viewController: UIViewController) {
        ManagerModernAVPlayer.shared.stop()

        guard let window = UIApplication.shared.keyWindow else { return }
        let viewContainer = UIView(frame: window.frame)
        window.addSubview(viewContainer)
        
        viewController.view.isUserInteractionEnabled = false

        
        let imageView = UIImageView(frame: currentFrame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        viewContainer.addSubview(imageView)
        viewContainer.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, animations: {
            imageView.frame = oldFrame
            imageView.cornerRadius = 8
            viewContainer.backgroundColor = UIColor(hexString: AppColor.shared.colorBackGround.value)
            imageView.layoutIfNeeded() // add this
        }) { _ in
            viewController.dismiss(animated: false) {
                viewController.view.isUserInteractionEnabled = true
                viewContainer.removeFromSuperview()
            }
        }

    }
    
    func gotoPlayMusic(id: String, viewController: UIViewController) {
        
    }
}

let keyAPIYoube = ["AIzaSyAHNKxx1sO5TncigKXZosIGe0JawzlyKho", "AIzaSyBHlgJLrt0E1wAkCc0zi-rvhG66sW6fbIA",
           "AIzaSyAZQJLPNXJn8zXgenrTP5qpSn2zlTiyJAA",
           "AIzaSyDm4OOro9OsSxnQ8zf8KdUXhPnHkZtkv84"
]
var currentKeyAPIYoube = "AIzaSyAHNKxx1sO5TncigKXZosIGe0JawzlyKho"

class ImageViewRound: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
    }
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
    }
}

//
//  SoftUIView.swift
//

import UIKit

@objc
public enum SoftUIViewType: Int {
    case pushButton
    case toggleButton
    case normal
}

open class SoftUIView: UIControl {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        createSubLayers()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubLayers()
    }

    open func setContentView(_ contentView: UIView?,
                             selectedContentView: UIView? = nil,
                             selectedTransform: CGAffineTransform? = CGAffineTransform.init(scaleX: 0.95, y: 0.95)) {

        resetContentView(contentView,
                         selectedContentView: selectedContentView,
                         selectedTransform: selectedTransform)
    }

    open var type: SoftUIViewType = .pushButton {
        didSet { updateShadowLayers() }
    }

    open var mainColor: CGColor = SoftUIView.defalutMainColorColor {
        didSet { updateMainColor() }
    }

    open var darkShadowColor: CGColor = SoftUIView.defalutDarkShadowColor {
        didSet { updateDarkShadowColor() }
    }

    open var lightShadowColor: CGColor = SoftUIView.defalutLightShadowColor {
        didSet { updateLightShadowColor() }
    }


    open override var bounds: CGRect {
        didSet { updateSublayersShape() }
    }

    open override var isSelected: Bool {
        didSet {
            updateShadowLayers()
            updateContentView()
        }
    }

    open override var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = true
        case .toggleButton:
            isSelected = !isSelected
        case .normal:
            break
        }
        super.touchesBegan(touches, with: event)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = isTracking
        case .normal, .toggleButton:
            break
        }
        super.touchesMoved(touches, with: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = false
        case .normal, .toggleButton:
            break
        }
        super.touchesEnded(touches, with: event)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = false
        case .normal, .toggleButton:
            break
        }
        super.touchesCancelled(touches, with: event)
    }

    private var backgroundLayer: CALayer!
    private var darkOuterShadowLayer: CAShapeLayer!
    private var lightOuterShadowLayer: CAShapeLayer!
    private var darkInnerShadowLayer: CAShapeLayer!
    private var lightInnerShadowLayer: CAShapeLayer!

    private var contentView: UIView?
    private var selectedContentView: UIView?
    private var selectedTransform: CGAffineTransform?

}
public var isDarkSoftUIView: Bool = false

extension SoftUIView {
    
//    public static let defalutMainColorColor: CGColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
//    public static let defalutDarkShadowColor: CGColor = #colorLiteral(red: 0.07992268599, green: 0.07992268599, blue: 0.07992268599, alpha: 1)
//    public static let defalutLightShadowColor: CGColor = #colorLiteral(red: 0.3685661765, green: 0.3618683116, blue: 0.3532916449, alpha: 1)
//
    
    public static var defalutMainColorColor: CGColor {
        if isDarkSoftUIView {
            return #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        } else {
            return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        }
    }
    public static var defalutDarkShadowColor: CGColor {
        if isDarkSoftUIView {
            return #colorLiteral(red: 0.07992268599, green: 0.07992268599, blue: 0.07992268599, alpha: 1)
        } else {
            return #colorLiteral(red: 0.8196078431, green: 0.8039215686, blue: 0.7803921569, alpha: 1)
        }
    }
    
    public static var defalutLightShadowColor: CGColor {
        if isDarkSoftUIView {
            return #colorLiteral(red: 0.3685661765, green: 0.3618683116, blue: 0.3532916449, alpha: 1)
        } else {
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

    public static let defalutShadowOffset: CGSize = .init(width: 6, height: 6)
    public static let defalutShadowOpacity: Float = 1
    public static let defalutShadowRadius: CGFloat = 5
    public static let defalutCornerRadius: CGFloat = 10

}

public extension SoftUIView {

    func createSubLayers() {
        shadowOffset = SoftUIView.defalutShadowOffset
        shadowOpacity = SoftUIView.defalutShadowOpacity
        shadowRadius = SoftUIView.defalutShadowRadius
        cornerRadius = SoftUIView.defalutCornerRadius
        
        lightOuterShadowLayer = {
            let shadowLayer = createOuterShadowLayer(shadowColor: lightShadowColor, shadowOffset: shadowOffset.inverse)
            layer.addSublayer(shadowLayer)
            return shadowLayer
        }()

        darkOuterShadowLayer = {
            let shadowLayer = createOuterShadowLayer(shadowColor: darkShadowColor, shadowOffset: shadowOffset)
            layer.addSublayer(shadowLayer)
            return shadowLayer
        }()

        backgroundLayer = {
            let backgroundLayer = CALayer()
            layer.addSublayer(backgroundLayer)
            backgroundLayer.frame = bounds
            backgroundLayer.cornerRadius = cornerRadius
            backgroundLayer.backgroundColor = mainColor
            return backgroundLayer
        }()

        darkInnerShadowLayer = {
            let shadowLayer = createInnerShadowLayer(shadowColor: darkShadowColor, shadowOffset: shadowOffset)
            layer.addSublayer(shadowLayer)
            shadowLayer.isHidden = true
            return shadowLayer
        }()

        lightInnerShadowLayer = {
            let shadowLayer = createInnerShadowLayer(shadowColor: lightShadowColor, shadowOffset: shadowOffset.inverse)
            layer.addSublayer(shadowLayer)
            shadowLayer.isHidden = true
            return shadowLayer
        }()

        updateSublayersShape()
    }

    func createOuterShadowLayer(shadowColor: CGColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = mainColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        return layer
    }

    func createOuterShadowPath() -> CGPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }

    func createInnerShadowLayer(shadowColor: CGColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = mainColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.fillRule = .evenOdd
        return layer
    }

    func createInnerShadowPath() -> CGPath {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: -100, dy: -100), cornerRadius: cornerRadius)
        path.append(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius))
        return path.cgPath
    }

    func createInnerShadowMask() -> CALayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        return layer
    }
//    đen ngoài
//    sáng ngoài
//
//    đen trong
//    đen trong
//
//    sáng trong
//    sáng trong
    

    func updateSublayersShape() {
        backgroundLayer.frame = bounds
        backgroundLayer.cornerRadius = cornerRadius

        darkOuterShadowLayer.path = createOuterShadowPath()
        lightOuterShadowLayer.path = createOuterShadowPath()
        darkInnerShadowLayer.path = createInnerShadowPath()
        lightInnerShadowLayer.path = createInnerShadowPath()
        
        darkInnerShadowLayer.mask = createInnerShadowMask()
        lightInnerShadowLayer.mask = createInnerShadowMask()
    }

    func resetContentView(_ contentView: UIView?,
                          selectedContentView: UIView? = nil,
                          selectedTransform: CGAffineTransform? = CGAffineTransform.init(scaleX: 0.95, y: 0.95)) {

        self.contentView.map {
            $0.transform = .identity
            $0.removeFromSuperview()
        }
        self.selectedContentView.map { $0.removeFromSuperview() }

        contentView.map {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }
        selectedContentView.map {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }

        self.contentView = contentView
        self.selectedContentView = selectedContentView
        self.selectedTransform = selectedTransform

        updateContentView()
    }

    func updateContentView() {
        if isSelected, selectedContentView != nil {
            showSelectedContentView()
        } else if isSelected, selectedTransform != nil {
            showSelectedTransform()
        } else {
            showContentView()
        }
    }

    func showContentView() {
        contentView?.isHidden = false
        contentView?.transform = .identity
        selectedContentView?.isHidden = true
    }

    func showSelectedContentView() {
        contentView?.isHidden = true
        contentView?.transform = .identity
        selectedContentView?.isHidden = false
    }

    func showSelectedTransform() {
        contentView?.isHidden = false
        selectedTransform.map { contentView?.transform = $0 }
        selectedContentView?.isHidden = true
    }

    func updateMainColor() {
        backgroundLayer.backgroundColor = mainColor
        darkOuterShadowLayer.fillColor = mainColor
        lightOuterShadowLayer.fillColor = mainColor
        darkInnerShadowLayer.fillColor = mainColor
        lightInnerShadowLayer.fillColor = mainColor
    }

    func updateDarkShadowColor() {
        darkOuterShadowLayer.shadowColor = darkShadowColor
        darkInnerShadowLayer.shadowColor = darkShadowColor
    }

    func updateLightShadowColor() {
        lightOuterShadowLayer.shadowColor = lightShadowColor
        lightInnerShadowLayer.shadowColor = lightShadowColor
    }

    func updateShadowOffset() {
        darkOuterShadowLayer.shadowOffset = shadowOffset
        lightOuterShadowLayer.shadowOffset = shadowOffset.inverse
        darkInnerShadowLayer.shadowOffset = shadowOffset
        lightInnerShadowLayer.shadowOffset = shadowOffset.inverse
    }

    func updateShadowOpacity() {
        darkOuterShadowLayer.shadowOpacity = shadowOpacity
        lightOuterShadowLayer.shadowOpacity = shadowOpacity
        darkInnerShadowLayer.shadowOpacity = shadowOpacity
        lightInnerShadowLayer.shadowOpacity = shadowOpacity
    }

    func updateShadowRadius() {
        darkOuterShadowLayer.shadowRadius = shadowRadius
        lightOuterShadowLayer.shadowRadius = shadowRadius
        darkInnerShadowLayer.shadowRadius = shadowRadius
        lightInnerShadowLayer.shadowRadius = shadowRadius
    }

    func updateShadowLayers() {
        darkOuterShadowLayer.isHidden = isSelected
        lightOuterShadowLayer.isHidden = isSelected
        darkInnerShadowLayer.isHidden = !isSelected
        lightInnerShadowLayer.isHidden = !isSelected
    }

}

extension CGSize {

    var inverse: CGSize {
        .init(width: -1 * width, height: -1 * height)
    }

}
//
//  RealmHelper.swift
//  Azibai
//
//  Created by Azi IOS on 12/6/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import RealmSwift

let REALM_HELPER = RealmHelper.shared

class RealmHelper {
    
    // MARK: - Properties
    static let shared = RealmHelper()
    var _realm: Realm!
}

// MARK: - Methods
extension RealmHelper {
    
    func configure() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        }, deleteRealmIfMigrationNeeded: true)
        
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        _realm = try! Realm()
        print("Realm Path", Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    // delete database
    func deleteDatabase() {
        try! _realm.write({
            _realm.deleteAll()
        })
    }
    
    // delete particular object
    func deleteObject(_ object : Object) {
        try? _realm.write ({
            _realm.delete(object)
        })
    }
    
    func deleteObjects<T: Object>(type: T.Type) {
        let objects = _realm.objects(T.self)
        try? _realm.write ({
            _realm.delete(objects)
        })
    }
    
    //Save array of objects to database
    func saveObjects(_ object: Object) {
        try? _realm.write ({
            _realm.add(object, update: .error)
//            _realm.add(object, update: false)
        })
    }
    
    // editing the object
    func editObjects(_ object: Object) {
        try? _realm.write ({
            _realm.add(object, update: .all)
//            _realm.add(object, update: true)
        })
    }
    
    //Returs an array as Results<object>?
    func getObjects<T: Object>(type: T.Type) -> Results<T>? {
        let objects = _realm.objects(T.self)
        return objects
    }
}
