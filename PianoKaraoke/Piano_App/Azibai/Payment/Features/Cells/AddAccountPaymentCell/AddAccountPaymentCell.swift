//
//  AddAccountPaymentCell.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol AddAccountPaymentCellDelegate: class {
    
}

class AddAccountPaymentCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 44
    }
    
    override func getCellName() -> String {
        return AddAccountPaymentCell.className
    }
}

class AddAccountPaymentCell: CellModelView<AddAccountPaymentCellModel> {
    
    weak var delegate: AddAccountPaymentCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? AddAccountPaymentCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: AddAccountPaymentCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
    @IBAction func clickAddAccount(_ sender: Any?) {
        guard let viewController = parentViewController else { return }
        PopupIGViewController.showAlert(viewController: viewController, title: "", dataSource: ["\tThêm tài khoản ngân hàng", "\tThêm tài khoản Momo"], hightLight: "", attributes: [NSAttributedString.Key.font : UIFont.kohoMedium14, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)]) { (text, _) in
            switch text {
            case "\tThêm tài khoản ngân hàng":
                AppRouter.shared.gotoPaymentCURD(viewController: viewController, type: .Add(.Bank))
            case "\tThêm tài khoản Momo":
                AppRouter.shared.gotoPaymentCURD(viewController: viewController, type: .Add(.Momo))
            default: break
            }
        }
    }
}
