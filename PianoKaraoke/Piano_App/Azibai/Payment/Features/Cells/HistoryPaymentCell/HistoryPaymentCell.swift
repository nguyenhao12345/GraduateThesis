//
//  HistoryPaymentCell.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol HistoryPaymentCellDelegate: class {
    
}

class HistoryPaymentCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 23 + 18 + 18 + 23 + 55.5
    }
    
    override func getCellName() -> String {
        return HistoryPaymentCell.className
    }
}

class HistoryPaymentCell: CellModelView<HistoryPaymentCellModel> {
    
    weak var delegate: HistoryPaymentCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? HistoryPaymentCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: HistoryPaymentCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
}



