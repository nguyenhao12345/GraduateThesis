//
//  AuthenticateViewController.swift
//  Piano_App
//
//  Created by Azibai on 24/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class AuthenticateViewController: AziBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var backGround1View: UIView!
    @IBOutlet weak var backGround2View: UIView!

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwdTF: UITextField!
    @IBOutlet weak var showPasswdBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!


    @IBOutlet weak var viewRegistExtra: UIView!
    @IBOutlet weak var viewLoginExtra: UIView!

    
    @IBOutlet weak var registView: UIView!
    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var registUserNameTF: UITextField!
    @IBOutlet weak var registPasswdTF: UITextField!
    @IBOutlet weak var registRePasswdTF: UITextField!
    @IBOutlet weak var registNameTF: UITextField!
    @IBOutlet weak var registFirstNameTF: UITextField!
    @IBOutlet weak var showResgistPasswdBtn: UIButton!
    @IBOutlet weak var showResgistRePasswdBtn: UIButton!


    @IBAction func clickShowPassWd(_ sender: Any?) {
        passwdTF.isSecureTextEntry = !passwdTF.isSecureTextEntry
        if #available(iOS 13.0, *) {
            showPasswdBtn.setImage(passwdTF.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func clickShowRegistPassWd(_ sender: Any?) {
        registPasswdTF.isSecureTextEntry = !registPasswdTF.isSecureTextEntry
        if #available(iOS 13.0, *) {
            showResgistPasswdBtn.setImage(registPasswdTF.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func clickShowRegistRePassWd(_ sender: Any?) {
        registRePasswdTF.isSecureTextEntry = !registRePasswdTF.isSecureTextEntry
        if #available(iOS 13.0, *) {
            showResgistRePasswdBtn.setImage(registRePasswdTF.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    override func initUIVariable() {
        super.initUIVariable()
        self.hidesNavigationbar = true
        self.hidesToolbar = true
    }
    var isFirstShowRegist: Bool = false
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registView.transform = CGAffineTransform(scaleX: 1, y: 0.00001)
        self.viewRegistExtra.transform = CGAffineTransform(scaleX: 1, y: 0.00001)

        viewIsReady()
    }
    
    //MARK: Method
    func viewIsReady() {
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.registBtn.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.loginBtn.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.backGround2View.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.backGround1View.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickLogin(_ sender: Any?) {
        if !isValidateUserName() { return }
        if !isValidatePasswd() { return }
        guard let userName = userNameTF.text,
            let pass = passwdTF.text else { return }
        LOADING_HELPER.show()
        ServiceOnline.share.checkLogin(email: userName, pass: pass) { (result) in
            switch result {
            case .error(let message):
                LOADING_HELPER.dismiss()
                self.showToast(string: message, duration: 2.0, position: .top)
            case .success(let data):
                ServiceOnline.share.getDataUser(uid: data.user.uid) { (data) in
                    LOADING_HELPER.dismiss()
                    guard let data = data as? [String: Any] else {
                        self.showToast(string: "User này chưa tồn tại trên hệ thống", duration: 2.0, position: .top)
                        return }
                    AppAccount.shared.updateUserModel(user: UserModel(data: data))
                }
            }
        }
    }
    
    @IBAction func clickChangeRegistToLogin(_ sender: Any?) {
        
        //ShowLoginView
        
        UIView.animate(withDuration: 0.3, animations: {
//            self.registView.setAnchorPoint(CGPoint(x: 0, y: 0))
            self.registView.transform = CGAffineTransform(scaleX: 1, y: 0.00001)
            self.viewRegistExtra.transform = self.registView.transform

        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.loginView.transform = .identity
                self.viewLoginExtra.transform = .identity
            }

        }
        
    }
    
    @IBAction func clickChangeLoginToRegist(_ sender: Any?) {
        UIView.animate(withDuration: 0.3, animations: {
//            self.loginView.setAnchorPoint(CGPoint(x: 0, y: 0))
            self.loginView.transform = CGAffineTransform(scaleX: 1, y: 0.00001)
            self.viewLoginExtra.transform = self.loginView.transform
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.registView.transform = .identity
                self.viewRegistExtra.transform = .identity
            }
        }
    }
    

    func isValidateUserName() -> Bool {
        if userNameTF.text == "" {
            self.showToast(string: "Tên đăng nhập không được để trống", duration: 2.0, position: .top)
            return false
        }
        return true
    }
    
    func isValidatePasswd() -> Bool {
        if passwdTF.text == "" {
            self.showToast(string: "Vui lòng nhập mật khẩu", duration: 2.0, position: .top)
            return false
        }
        return true
    }

    //MARK: Regist
    
    func isValidateRegistName() -> Bool {
        if registNameTF.text == "" {
            self.showToast(string: "Tên không được để trống", duration: 2.0, position: .top)
            return false
        }
        return true
    }
    
    func isValidateRegistFirstName() -> Bool {
        if registFirstNameTF.text == "" {
            self.showToast(string: "Họ không được để trống", duration: 2.0, position: .top)
            return false
        }
        return true
    }
    
    func isValidateRegistUserName() -> Bool {
        if registUserNameTF.text == "" {
            self.showToast(string: "Tên đăng nhập không được để trống", duration: 2.0, position: .top)
            return false
        }
        return true
    }
    
    func isValidateRegistPasswd() -> Bool {
        if registPasswdTF.text == "" {
            self.showToast(string: "Vui lòng nhập mật khẩu", duration: 2.0, position: .top)
            return false
        }
        return true
    }
    
    func isValidateRegistRePasswd() -> Bool {
        if registPasswdTF.text != registRePasswdTF.text {
            self.showToast(string: "Nhập lại mật khẩu không đúng", duration: 2.0, position: .top)
            return false
        }
        return true
    }
    
    @IBAction func clickRegist(_ sender: Any?) {
        if !isValidateRegistName() { return }
        if !isValidateRegistFirstName() { return }
        if !isValidateRegistUserName() { return }
        if !isValidateRegistPasswd() { return }
        if !isValidateRegistRePasswd() { return }
        
        guard let userName = registUserNameTF.text,
            let pass = registPasswdTF.text,
            let firstname = registFirstNameTF.text,
            let name = registNameTF.text else { return }
        LOADING_HELPER.show()
        ServiceOnline.share.registAccount(email: userName, password: pass) { (result) in
            LOADING_HELPER.dismiss()
            switch result {
            case .error(let message):
                self.showToast(string: message, duration: 2.0, position: .top)
            case .success(let data):

                ServiceOnline.share.pushDataRegistUser(uid: data.user.uid,
                                                       data: UserModel(data: ["UID": data.user.uid,
                                                                              "name": firstname + " " + name,
                                                                              "phone": "",
                                                                              "avata": ""]))
                
                AppAccount.shared.updateUserModel(user: UserModel(data: ["UID": data.user.uid,
                                                                         "name": firstname + " " + name,
                                                                         "phone": "",
                                                                         "avata": ""]))
            }
        }
    }
}
