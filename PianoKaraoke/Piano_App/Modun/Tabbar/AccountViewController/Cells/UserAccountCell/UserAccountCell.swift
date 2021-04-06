//
//  UserAccountCell.swift
//  Piano_App
//
//  Created by Azibai on 24/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol UserAccountCellDelegate: class {
    
}

class UserAccountCellModel: AziBaseCellModel {
    
    var user: UserModel? = AppAccount.shared.getUserLogin()
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 80
    }
    
    override func getCellName() -> String {
        return UserAccountCell.className
    }
}

class UserAccountCell: CellModelView<UserAccountCellModel> {
    
    weak var delegate: UserAccountCellDelegate?
    @IBOutlet weak var avataImg: ImageViewRound!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? UserAccountCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.avataImg.borderColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        self.avataImg.borderWidth = 2
        initGesture()
    }
    
    override func bindCellModel(_ cellModel: UserAccountCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        avataImg.setImageURL(URL(string: cellModel.user?.avata ?? ""))
        userNameLbl.text = cellModel.user?.name
        nextBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
    
    func initGesture() {
        let tapAvt = UITapGestureRecognizer(target: self, action: #selector(self.clickAvt))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapAvt)
    }
    
    @objc func clickAvt(_ sender: Any) {
        guard let viewController = parentViewController,
            let uid = AppAccount.shared.getUserLogin()?.uid else { return }
        AppRouter.shared.gotoUserWall(uidUSer: uid, viewController: viewController)
    }

}



