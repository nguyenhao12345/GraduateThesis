//
//  InfoUserViewController.swift
//  Piano_App
//
//  Created by Azibai on 25/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class InfoUserViewController: AziBaseViewController {
    
    var frameImageLast: CGRect = .zero
    
    //MARK: Outlets
    @IBOutlet weak var avtImgView: ImageViewRound!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backGround1View: UIView!
    @IBOutlet weak var backGround2View: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("self.frameImageLast: \(self.frameImageLast)")
        viewContent.transform = CGAffineTransform(translationX: -500, y: 0)
        btnSave.transform = CGAffineTransform(translationX: 0, y: 500)
        avtImgView.transform = CGAffineTransform(translationX: 500, y: 0)
        UIView.animate(withDuration: 0.6) {
            self.viewContent.transform = .identity
            self.btnSave.transform = .identity
            self.avtImgView.transform = .identity
        }
    }

    //MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        print("self.frameImageLast: \(self.frameImageLast)")

        UIView.animate(withDuration: 0.6, animations: {
            self.viewContent.transform = CGAffineTransform(translationX: 500, y: 0)
            self.btnSave.transform = CGAffineTransform(translationX: 0, y: 500)
            self.avtImgView.transform = CGAffineTransform(translationX: -500, y: 0)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
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
        if let currentUser = AppAccount.shared.getUserLogin() {
            avtImgView.setImageURL(URL(string: currentUser.avata))
            address.text = currentUser.address
            phone.text = currentUser.phone
            userName.text = currentUser.name
        }
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.btnSave.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.navView.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.backGround2View.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.backGround1View.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
    }
}

