//
//  NewsFeedInfoCell.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol NewsFeedInfoCellDelegate: class {
   func clickMoreBtn()
}

class NewsFeedInfoCellModel: AziBaseCellModel {
    let heightImg: CGFloat = 48
    let margin: CGFloat = 12
    let heightDate: CGFloat = 16
    
    var userName: String = "Nguyễn Hiếu"
    var dateStr: String = "Hôm nay"
    var avataStr: String = ""
    var id: String = ""
    var admin: Int = 0
    func heightNameUser(maxW: CGFloat) -> CGFloat {
        let heightText = heightForView(textAtt: Helper.getAttributesStringWithFontAndColor(string: userName, font: .HelveticaNeueBold16, color: .clear), width: maxW, numberOfline: 0)

        return heightDate + heightText + 4
    }
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        if finalHeight == -1 {
            finalHeight = max(heightImg, heightNameUser(maxW: maxWidth-80-51)) + 24
        }
        return finalHeight
    }
    
    override func getCellName() -> String {
        return NewsFeedInfoCell.className
    }
}

class NewsFeedInfoCell: CellModelView<NewsFeedInfoCellModel> {
    
    weak var delegate: NewsFeedInfoCellDelegate?
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var avtUserImg: ImageViewRound!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var adminButton: UIButton!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? NewsFeedInfoCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.avtUserImg.borderColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        self.avtUserImg.borderWidth = 2
        initGesture()
    }
    
    override func bindCellModel(_ cellModel: NewsFeedInfoCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        adminButton.isHidden = cellModel.admin != 1
        userNameLbl.text = cellModel.userName
        dateLbl.text = cellModel.dateStr
        avtUserImg.setImageURL(URL(string: cellModel.avataStr))
    }
    
    func initGesture() {
        let tapAvt = UITapGestureRecognizer(target: self, action: #selector(self.clickAvt))
        avtUserImg.isUserInteractionEnabled = true
        avtUserImg.addGestureRecognizer(tapAvt)
    }
    
    @objc func clickAvt(_ sender: Any) {
        guard let viewController = parentViewController,
            let uid = cellModel?.id else { return }
        
        if let userWall = viewController as? UserWallViewController {
            if userWall.uidUser == uid {
                userWall.view.shake(direction: .horizontal, duration: 0.5, animationType: .easeOut, completion: nil)
            } else {
                AppRouter.shared.gotoUserWall(uidUSer: uid, viewController: viewController)
            }
        } else {
            AppRouter.shared.gotoUserWall(uidUSer: uid, viewController: viewController)
        }
    }

    @IBAction func clickMore(_ sender: Any?) {
        delegate?.clickMoreBtn()
    }
}



