//  AziBaseViewController.swift
//  Hiếu nè
//
//  Created by Azibai on 12/06/2020.
//  Copyright © 2020 Azibai. All rights reserved.
//
import Hero

public class AziBaseViewController: UIViewController {
    
    public enum TypeAction {
        case HaveLoadMore
        case HaveRefresh
        case LoadMoreAndRefresh
        case None
    }

    public let sectionBuilder = SectionBuilder()
    var lastContentOffset:  CGFloat = 0

    public var viewDidAppearCount:              Int  = -1
    public var hidesNavigationbar:              Bool = false
    public var hidesToolbar:                    Bool = false
    public var isAppearOnScreen:                Bool = false
    public var allowAutoPlay:                   Bool = false
    public var addKeyboardListenerEvent:        Bool = false
    public var addPansGesture:                  Bool = false
    public var colorStatusBar:                  UIColor = .white
    
    private var nearestIndex:                   CGFloat = 0.0 //auto play
    private var isViewReappear:                 Bool = false
    private var panGR :                         UIPanGestureRecognizer!
    private var edgePanGR:                      UIScreenEdgePanGestureRecognizer!
    private var progressBool:                   Bool = false
    private var dismissBool:                    Bool = true
    private var isEdgePaning:                   Bool = false
    private var dicRectionPanStart:             PanDirection = .down
    private var dicRectionPanChange:            PanDirection = .down

    var refreshControl: UIRefreshControl {
        let _refreshControl = UIRefreshControl()
        _refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        _refreshControl.tintColor = stringToColor(stringColor: "737373")
//        _refreshControl.attributedTitle = NSAttributedString(string: "Tải lại dữ liệu ...", attributes: [NSAttributedString.Key.font: UIFont(name: "KoHo", size: 14)!, NSAttributedString.Key.foregroundColor: stringToColor(stringColor: "737373")])
        return _refreshControl
    }

    //MARK: Need define
    public func initUIVariable() {
        if addPansGesture {
            self.isHeroEnabled = true
        }
    }
    
    public func getBackgroundColorStatus() -> UIColor {
        return .white
    }
    
    public func getTypeAction() -> TypeAction {
        return .None
    }
    
    public func loadMore() {
        
    }
    
    @objc public func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    public func getScrollView() -> UIScrollView? {
        return nil
    }
    
    public func keyboardShowHeight(_ height:CGFloat) {
        
    }
    
    public func keyboardHide() {
        
    }


    //MARK: LifeCycle
    
    public func viewDidReappear() {
           
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initUIVariable()
        if addPansGesture {
            initGesture()
        }
        addZoomMediaInCellListener()
        if let collectionView = getScrollView() as? UICollectionView {
            if getTypeAction() == .HaveRefresh || getTypeAction() == .LoadMoreAndRefresh {
                collectionView.refreshControl = refreshControl
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         self.viewDidAppearCount += 1
         self.isAppearOnScreen = true
     }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isAppearOnScreen = true
        self.checkReappear()
        self.setCurrentNavigationVariable()
        self.setCurrentStatusVariable()
        if self.addKeyboardListenerEvent {
            self.addKeyboardListener()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isAppearOnScreen = false
        if self.addKeyboardListenerEvent {
            self.removeKeyboardListener()
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isAppearOnScreen = false
        CustomAVPlayer.globalPlayer?.pause()
    }
    
    func panWithNormal(recognizer : UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: nil)
        let progressX = (translation.x / 2 ) / view.bounds.width
        let progressY = (translation.y / 2 ) / view.bounds.height
         
        if(recognizer.direction == .up || recognizer.direction == .down ) {
            if(dismissBool) {
                dismissBool = false
                hero.dismissViewController()
                self.heroModalAnimationType = (recognizer.direction == .up) ? .pageOut(direction: .up) : .pageOut(direction: .down)
                progressBool = true
                recognizer.setTranslation(.zero, in: view)
            }
        }
        
        switch recognizer.state {
        case .began: print("began")
        case .changed:
            if(progressBool) {
                let currentPos = CGPoint(x: view.center.x , y: translation.y + view.center.y)
                Hero.shared.update(progressY)
                Hero.shared.apply(modifiers: [.position(currentPos)], to: view)
            }
        default:
            dismissBool = true
            progressBool = false
            if abs(progressY + recognizer.velocity(in: nil).y / view.bounds.height ) > 0.5 { Hero.shared.finish() }
            else
            if progressX + recognizer.velocity(in: nil).x / view.bounds.width > 0.5 {
                ManagerModernAVPlayer.shared.stop()
                Hero.shared.finish() }
            else { Hero.shared.cancel() }
        }
    }
    
    //MARK: Notifi
    private func removeKeyboardListener() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addZoomMediaInCellListener() {
//        NotificationCenter.default
//            .addObserver(self,
//                         selector: #selector(setScrollDisable),
//                         name: NSNotification.Name.CellisZooming, object: nil)
//
//        NotificationCenter.default
//            .addObserver(self,
//                         selector: #selector(setScrollEnabled),
//                         name: NSNotification.Name.CellStopZoom, object: nil)
    }
    
    //MARK: Method
    public func setCurrentNavigationVariable() {
        self.navigationController?.setNavigationBarHidden(self.hidesNavigationbar, animated: false)
        self.navigationController?.setToolbarHidden(self.hidesToolbar, animated: false)
    }
    
    public func setCurrentStatusVariable() {
//        UIApplication.shared.statusBarView?.backgroundColor = colorStatusBar
//        UIApplication.shared.statusBarStyle = .lightContent
//            (colorStatusBar == UIColor.black) ? .lightContent : .default
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if colorStatusBar == UIColor.black {
            return .lightContent
        }
        if colorStatusBar == UIColor.white {
            return .default
        }
        return .default
    }
    
    func checkReappear() {
        if self.isViewReappear {
            self.viewDidReappear()
        }
        self.isViewReappear = true
    }
    
    @objc private func setScrollEnabled() {
        getScrollView()?.isScrollEnabled = true
        dismissBool = true
    }
    
    @objc private func setScrollDisable() {
        getScrollView()?.isScrollEnabled = false
        dismissBool = false
    }
    
    private func removeAllNotifi() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        self.keyboardShowHeight(keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.keyboardHide()
    }
    
    private func initGesture() {
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGR.delegate = self
        view.addGestureRecognizer(panGR)
        
        if navigationController?.interactivePopGestureRecognizer == nil {
            edgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(screenEdgePan))
            edgePanGR.edges = .left
            view.addGestureRecognizer(edgePanGR)
        }

        getScrollView()?.bouncesZoom = false
    }
    
    deinit {
        removeAllNotifi()
    }
}

//MARK: UIScrollViewDelegate
extension AziBaseViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !allowAutoPlay { return }
        guard let cls = getScrollView() as? UICollectionView else { return }
        if scrollView.isDecelerating {
            let currentIndex = ((CGFloat(scrollView.contentOffset.y) / scrollView.bounds.size.height).rounded(.up))
            if currentIndex >= self.nearestIndex {
                ASVideoPlayerController.sharedVideoPlayer.pausePlayVideoVertical2(collectionView: cls)
            }
        } else {
            ASVideoPlayerController.sharedVideoPlayer.pausePlayVideoVertical2(collectionView: cls)
        }

    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !allowAutoPlay { return }
        self.nearestIndex = (CGFloat(targetContentOffset.pointee.y) / scrollView.bounds.size.height).rounded(.up)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !allowAutoPlay { return }
        if !decelerate {
            guard let cls = getScrollView() as? UICollectionView else { return }
            ASVideoPlayerController.sharedVideoPlayer.pausePlayVideoVertical2(collectionView: cls)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !allowAutoPlay { return }
        guard let cls = getScrollView() as? UICollectionView else { return }
        ASVideoPlayerController.sharedVideoPlayer.pausePlayVideoVertical2(collectionView: cls)
    }
    
}

//MARK: PanGesture + ScreenEdgePan + UIGestureRecognizerDelegate
extension AziBaseViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    
    
    @objc private func screenEdgePan(recognizer: UIScreenEdgePanGestureRecognizer) {
        isEdgePaning = true
        guard let view = recognizer.view else { return }
        let translation = recognizer.translation(in: nil)
        let progress = translation.x / 2 / view.bounds.width
        
        switch recognizer.state {
        case .began:
            hero.dismissViewController()
            self.heroModalAnimationType = .pageOut(direction: .right)
//                .uncover(direction: .right)
        case .changed:
            Hero.shared.update(progress)
        default:
            if abs(progress + recognizer.velocity(in: nil).x / view.bounds.width) > 0.5 {
                ManagerModernAVPlayer.shared.stop()
                Hero.shared.finish() }
            else { Hero.shared.cancel()}
            isEdgePaning = false
        }
    }
    
    @objc private func pan(recognizer : UIPanGestureRecognizer) {
        if isEdgePaning { return }

        guard let collectionView = getScrollView() else {
            panWithNormal(recognizer: recognizer)
            return }
        
        let translation = recognizer.translation(in: nil)
        let progressX = (translation.x / 2 ) / view.bounds.width
        let progressY = (translation.y / 2 ) / view.bounds.height
        
        if((recognizer.direction == .up         &&
            collectionView.isAtBottom           &&
            (getTypeAction() != .HaveLoadMore   &&
             getTypeAction() != .LoadMoreAndRefresh)) ||
            (recognizer.direction == .down      &&
             collectionView.isAtTop             &&
            (getTypeAction() != .HaveRefresh    &&
             getTypeAction() != .LoadMoreAndRefresh))) {
            
            if dismissBool {
                getScrollView()?.isScrollEnabled = false
                dismissBool = false
                hero.dismissViewController()
                if self.navigationController != nil {
                    if collectionView.isAtTop {
                        dicRectionPanStart = .down
                        dicRectionPanChange = .down
                        self.navigationController?.heroModalAnimationType = .pageOut(direction: .down)
//                            .uncover(direction: .down)
                    }
                    else {
                        dicRectionPanStart = .up
                        dicRectionPanChange = .up
                        self.navigationController?.heroModalAnimationType = .pageOut(direction: .up)
//                            .uncover(direction: .up)
                    }
                }
                else {
                    if collectionView.isAtTop {
                        dicRectionPanStart = .down
                        dicRectionPanChange = .down
                        self.heroModalAnimationType = .pageOut(direction: .down)
//                            .uncover(direction: .down)
                    }
                    else {
                        dicRectionPanStart = .up
                        dicRectionPanChange = .up
                        self.heroModalAnimationType = .pageOut(direction: .up)
//                            .uncover(direction: .up)
                    }
                }
                progressBool = true
                recognizer.setTranslation(.zero, in: view)
            }
        }

        switch recognizer.state {
        case .began: print("Began Pan")
        case .changed:
            if progressBool {
                
                if recognizer.direction == .up {
                    dicRectionPanChange = .up
                } else if recognizer.direction == .down {
                    dicRectionPanChange = .down
                }
                
                if let sender = self.navigationController {
                    let currentPos = CGPoint(x: view.center.x , y: translation.y + view.center.y)
                    Hero.shared.update(progressY)
                    Hero.shared.apply(modifiers: [.position(currentPos)], to: sender.view)
                }
                else {
                    let currentPos = CGPoint(x: view.center.x , y: translation.y + view.center.y)
                    Hero.shared.update(progressY)
                    Hero.shared.apply(modifiers: [.position(currentPos)], to: view)
                }
            }
        default:
            getScrollView()?.isScrollEnabled = true
            dismissBool = true
            progressBool = false
            if dicRectionPanChange != dicRectionPanStart {
                if navigationController != nil {
                    self.navigationController?.heroModalAnimationType = .pageOut(direction: .right)
//                        .uncover(direction: .right)
                }
                else {
                    self.heroModalAnimationType = .pageOut(direction: .right)
//                        .uncover(direction: .right)
                }
                Hero.shared.cancel()
                dicRectionPanChange = .down
                dicRectionPanStart = .down
                return
            }

            if abs(progressY + recognizer.velocity(in: nil).y / view.bounds.height ) > 0.5 {
                ManagerModernAVPlayer.shared.stop()
                Hero.shared.finish() }
            else
            if progressX + recognizer.velocity(in: nil).x / view.bounds.width > 0.5 {
                ManagerModernAVPlayer.shared.stop()
                Hero.shared.finish() }
            else {
                if navigationController != nil {
                    self.navigationController?.heroModalAnimationType = .pageOut(direction: .right)
//                        .uncover(direction: .right)
                }
                else {
                    self.heroModalAnimationType = .pageOut(direction: .right)
//                        .uncover(direction: .right)
                }
                Hero.shared.cancel()
            }
        }
    }
}


extension UIColor {

    // COPY at: https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    // Check if the color is light or dark, as defined by the injected lightness threshold.
    // Some people report that 0.7 is best. I suggest to find out for yourself.
    // A nil value is returned if the lightness couldn't be determined.
    func isLight(threshold: Float = 0.5) -> Bool? {
        let originalCGColor = self.cgColor

        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }

        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
class BaseNavigationController: UINavigationController {
    
    var previousViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
