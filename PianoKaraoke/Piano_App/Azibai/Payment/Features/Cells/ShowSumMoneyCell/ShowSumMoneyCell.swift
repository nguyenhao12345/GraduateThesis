//
//  ShowSumMoneyCell.swift
//  Piano_App
//
//  Created by Azibai on 09/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol ShowSumMoneyCellDelegate: class {
    func clickDrawMoney()
    func clickViewDetail()
}

class ShowSumMoneyCellModel: AziBaseCellModel {
    var isHiddenButton: Bool = false
    var moneyStr: String = ""
    var title: String = ""
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 120 + 32
    }
    
    override func getCellName() -> String {
        return ShowSumMoneyCell.className
    }
}

class ShowSumMoneyCell: CellModelView<ShowSumMoneyCellModel> {
    
    weak var delegate: ShowSumMoneyCellDelegate?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? ShowSumMoneyCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: ShowSumMoneyCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        titleLbl.text = cellModel.title
        moneyLbl.text = cellModel.moneyStr
        btn.isHidden = cellModel.isHiddenButton
    }
    
    @IBAction func clickBtn(_ sender: Any?) {
        delegate?.clickViewDetail()
    }
}



