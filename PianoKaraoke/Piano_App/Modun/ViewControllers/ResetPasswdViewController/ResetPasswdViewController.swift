//
//  ResetPasswdViewController.swift
//  Piano_App
//
//  Created by Azibai on 25/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class ResetPasswdViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var backGround1View: UIView!
    @IBOutlet weak var backGround2View: UIView!
    @IBOutlet weak var viewContent: UIView!

    @IBOutlet weak var changePassBtn: UIButton!
    @IBOutlet weak var passOldTF: UITextField!
    @IBOutlet weak var passNewTF: UITextField!
    @IBOutlet weak var rePassNewTF: UITextField!
    
    @IBAction func clickChangePass(_ sender: Any?) {
        guard let passOld = passOldTF.text else { return }
        guard let passNew = passNewTF.text else { return }
        guard let passReNew = rePassNewTF.text else { return }

        LOADING_HELPER.show()
        ServiceOnline.share.changePasswd(oldPass: passOld, newPasss: passNew) { (mess) in
            LOADING_HELPER.dismiss()
            if mess == "Thành công" {
                self.showToast(string: "Đổi mật khẩu thành công", duration: 2, position: .top) { _ in
                    self.clickBack(nil)
                }
            } else {
                self.showToast(string: mess, duration: 2, position: .top)
            }
        }
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    

    //MARK: Init

    
    override func initUIVariable() {
        super.initUIVariable()
        self.hidesNavigationbar = true
        self.hidesToolbar = true
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
    }
    
    //MARK: Method
    func viewIsReady() {
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.changePassBtn.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.backGround2View.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.backGround1View.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.viewContent.setAnchorPoint(CGPoint(x: 0, y: 0))
//        self.viewContent.transform = CGAffineTransform(scaleX: 1, y: 0.00001)
//
//        UIView.animate(withDuration: 0.5, animations: {
//            self.viewContent.transform = .identity
//        })
    }

}
