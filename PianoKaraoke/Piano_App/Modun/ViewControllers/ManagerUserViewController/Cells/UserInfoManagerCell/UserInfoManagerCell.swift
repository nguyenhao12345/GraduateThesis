//
//  UserInfoManagerCell.swift
//  Piano_App
//
//  Created by Azibai on 23/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol UserInfoManagerCellDelegate: class {
    func remove()
}

class UserInfoManagerCellModel: AziBaseCellModel {
    let heightImg: CGFloat = 48
    let margin: CGFloat = 12
    var userModel: UserModel?
    func heightNameUser(maxW: CGFloat) -> CGFloat {
        let heightText = heightForView(textAtt: Helper.getAttributesStringWithFontAndColor(string: userModel?.name ?? "", font: .HelveticaNeueBold16, color: .clear), width: maxW, numberOfline: 0)
        return heightText
    }
    
    func heightUID(maxW: CGFloat) -> CGFloat {
        let heightText = heightForView(textAtt: Helper.getAttributesStringWithFontAndColor(string: "UID: " + (userModel?.uid ?? ""), font: .HelveticaNeueLight12, color: .clear), width: maxW, numberOfline: 0)
        return heightText
    }
    
    func heightYoutubekey(maxW: CGFloat) -> CGFloat {
        let heightText = heightForView(textAtt: Helper.getAttributesStringWithFontAndColor(string: "Key: " + (userModel?.keyYoutube ?? ""), font: .HelveticaNeueLight12, color: .clear), width: maxW, numberOfline: 0)
        return heightText
    }



    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        if finalHeight == -1 {
            finalHeight = max(heightImg, heightNameUser(maxW: maxWidth-68-43) + 6 + heightUID(maxW: maxWidth-68-43) + 6 + heightYoutubekey(maxW: maxWidth-68-43)) + 24
        }
        return finalHeight
    }
    
    override func getCellName() -> String {
        return UserInfoManagerCell.className
    }
}

class UserInfoManagerCell: CellModelView<UserInfoManagerCellModel> {
    
    weak var delegate: UserInfoManagerCellDelegate?
    @IBOutlet weak var avtUserImg: ImageViewRound!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var uidLbl: UILabel!
    @IBOutlet weak var keyYoutubeLbl: UILabel!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? UserInfoManagerCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: UserInfoManagerCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        adminButton.isHidden = cellModel.userModel?.admin != 1
        avtUserImg.setImageURL(URL(string: cellModel.userModel?.avata ?? ""))
        userNameLbl.text = cellModel.userModel?.name
        keyYoutubeLbl.text = "Key: " + (cellModel.userModel?.keyYoutube ?? "")
        uidLbl.text = "UID: " + (cellModel.userModel?.uid ?? "")
    }
    
    @IBAction func clickMore(_ sender: Any?) {
        guard let viewController = parentViewController else { return }
        PopupIGViewController.showAlert(viewController: viewController, title: "", dataSource: ["\tXem thông tin", "\tVào trang cá nhân", "\tGia hạn Key", "\tXoá tài khoản"], hightLight: "", attributes: [NSAttributedString.Key.font : UIFont.HelveticaNeue16, NSAttributedString.Key.foregroundColor : UIColor.defaultText]) { (str, index) in
            switch index {
            case 0:
                AppRouter.shared.gotoInfoUser(uidUser: self.cellModel?.userModel?.uid ?? "", viewController: viewController)
            case 1:
                AppRouter.shared.gotoUserWall(uidUSer: self.cellModel?.userModel?.uid ?? "", viewController: viewController)
            case 2:
                let key = keyAPIYoube.random()
                ServiceOnline.share.editKeyYoutube(user: (self.cellModel?.userModel!)!, keyYoutube: key)
                self.cellModel?.userModel?.keyYoutube = key
                self.cellModel?.updateCell()
            case 3:
                ServiceOnline.share.removeUser(user: (self.cellModel?.userModel!)!)
                self.delegate?.remove()
            default: break
            }
        }
    }
}



