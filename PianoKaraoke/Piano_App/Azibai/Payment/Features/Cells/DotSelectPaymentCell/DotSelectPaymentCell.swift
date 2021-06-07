//
//  DotSelectPaymentCell.swift
//  Piano_App
//
//  Created by Azibai on 14/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol DotSelectPaymentCellDelegate: class {
    func selectedCell(_ cellModel: DotSelectPaymentCellModel)
}

class DotSelectPaymentCellModel: AziBaseCellModel {
    
    var title: String = ""
    var isSelected: Bool = false
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 36
    }
    
    override func getCellName() -> String {
        return DotSelectPaymentCell.className
    }
}

class DotSelectPaymentCell: CellModelView<DotSelectPaymentCellModel> {
    
    weak var delegate: DotSelectPaymentCellDelegate?
    @IBOutlet weak var imageViewDot: UIImageView!
    @IBOutlet weak var lbl: UILabel!

    @IBAction func click(_ sender: Any?) {
        delegate?.selectedCell(cellModel!)
    }
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? DotSelectPaymentCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: DotSelectPaymentCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        imageViewDot.image = cellModel.isSelected ? UIImage(named: "PaymentActive") : UIImage(named: "PaymentInactive")
        lbl.text = cellModel.title
    }
    
}



