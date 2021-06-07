//
//  PaymentNoteCell.swift
//  Piano_App
//
//  Created by Azibai on 14/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol PaymentNoteCellDelegate: class {
    
}

class PaymentNoteCellModel: AziBaseCellModel {
    var att: NSMutableAttributedString?
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        guard let att = att else { return 0 }
        return heightForView(textAtt: att, width: maxWidth - 26*2, numberOfline: 0) + 26*2 + topMargin + bottomMargin
    }
    
    override func getCellName() -> String {
        return PaymentNoteCell.className
    }
}

class PaymentNoteCell: CellModelView<PaymentNoteCellModel> {
    
    weak var delegate: PaymentNoteCellDelegate?
    @IBOutlet weak var mesLbl: UILabel!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? PaymentNoteCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: PaymentNoteCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        mesLbl.attributedText = cellModel.att
    }
    
}



