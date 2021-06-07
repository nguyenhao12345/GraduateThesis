//
//  AccountPaymentCell.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol AccountPaymentCellDelegate: class {
    func edit()
    func remove()
}

class AccountPaymentCellModel: AziBaseCellModel {
    var attTitle: NSMutableAttributedString?
    var attContent: NSMutableAttributedString?
    var isHiddenBtn: Bool = false
//    var type: CURDPaymentAccountViewController.TYPE = .Add(.Momo)
    
    init(attTitle: NSMutableAttributedString?,
         attContent: NSMutableAttributedString?,
         isHiddenBtn: Bool = false
//         type: CURDPaymentAccountViewController.TYPE
    ) {
        self.attTitle = attTitle
        self.attContent = attContent
        self.isHiddenBtn = isHiddenBtn
//        self.type = type
        super.init()
    }
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        let iconW: CGFloat = isHiddenBtn ? 0: 26
        let heightContent = heightForView(textAtt: attContent!, width: maxWidth - (maxWidth*0.45 - 32) - 26 - 12 - iconW, numberOfline: 0)
        let heightTitle = heightForView(textAtt: attTitle!, width: maxWidth*0.45-32, numberOfline: 0)
        return max(heightTitle, heightContent)
    }
    
    override func getCellName() -> String {
        return AccountPaymentCell.className
    }
}

class AccountPaymentCell: CellModelView<AccountPaymentCellModel> {
    
    weak var delegate: AccountPaymentCellDelegate?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? AccountPaymentCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: AccountPaymentCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        editBtn.isHidden = cellModel.isHiddenBtn
        titleLbl.attributedText = cellModel.attTitle
        contentLbl.attributedText = cellModel.attContent
    }
    
    @IBAction func clickEditBtn(_ sender: Any?) {
        guard 
            let viewController = parentViewController else { return }
        PopupIGViewController.showAlert(viewController: viewController, title: "", dataSource: ["\tChỉnh sửa", "\tXoá"], hightLight: "") { [weak self] (value, index) in
            switch index {
            case 0:
                self?.delegate?.edit()
            case 1:
                self?.delegate?.remove()
            default: break
            }
        }
    }
}
