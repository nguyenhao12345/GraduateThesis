//
//  TabbarViewController.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import ESTabBarController_swift
import UIKit


class ExampleBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ExampleBouncesContentView: ExampleBasicContentView {

    public var duration = 0.3

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }

    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}

class ExampleTipsBasicContentView: ExampleBouncesContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = .gray
        highlightTextColor = UIColor.init(hexString: "FF1678")!
        iconColor = .gray
        highlightIconColor = UIColor.init(hexString: "FF1678")!
        
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.highlightIconColor = UIColor.init(hexString: hex)!
                self?.highlightTextColor = UIColor.init(hexString: hex)!
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class TabbarViewController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v1 = FeedsViewController()
        let v3 = PracticeViewController()
        let v4 = AccountViewController()

        v3.tabBarItem = ESTabBarItem.init(ExampleTipsBasicContentView(), title: "Trang chủ", image: UIImage(named: "27home"), selectedImage: UIImage(named: "28homed"))
        v1.tabBarItem = ESTabBarItem.init(ExampleTipsBasicContentView(), title: "Khám phá", image: UIImage(named: "Vectorkhampha"), selectedImage: UIImage(named: "khamphaed"))
        v4.tabBarItem = ESTabBarItem.init(ExampleTipsBasicContentView(), title: "Quản lý", image: UIImage(named: "Artboard 1 copy 34"), selectedImage: UIImage(named: "Artboard 1 copy 34"))

        let nav1 = UINavigationController(rootViewController: v1)
        
        let nav3 = UINavigationController(rootViewController: v3)
        nav3.hidesBottomBarWhenPushed = true
        let nav4 = UINavigationController(rootViewController: v4)
        nav4.hidesBottomBarWhenPushed = true

        self.viewControllers = [nav1, nav3, nav4]

        self.tabBar.backgroundImage = UIImage(named: "transparent")

        self.tabBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)

        self.selectedIndex = 0
    }

}

