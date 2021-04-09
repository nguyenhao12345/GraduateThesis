//
//  AppAccount.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Foundation

class AppAccount: NSObject {
    static let shared: AppAccount = AppAccount()
    private var user: UserModel? {
        return REALM_HELPER.getObjects(type: UserModel.self)?.filter("id = 1").first
    }

    func updateUserModel(user: UserModel) {
//        self.user = user
        REALM_HELPER.editObjects(user)

        LocalVideoManager.shared.removeAllLocalFile()
        AppDelegate.shared.setUpScreenNavigation()
//        let vc = TabbarViewController()
//        AppDelegate.shared.window?.rootViewController = vc
//        AppDelegate.shared.window?.makeKeyAndVisible()
//
//        AppColor.shared.colorBackGround.subscribe(onNext: { (hex) in
//            UIView.animate(withDuration: 0.7) {
//                UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
//            }
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }
    
    func getUserLogin() -> UserModel? {
        return user
    }
}
