//
//  EditButtonRightCell.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol EditButtonRightCellDelegate: class {

}

class EditButtonRightCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    override func getCellName() -> String {
        return EditButtonRightCell.className
    }
}

class EditButtonRightCell: CellModelView<EditButtonRightCellModel> {
    
    weak var delegate: EditButtonRightCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? EditButtonRightCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: EditButtonRightCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
}



