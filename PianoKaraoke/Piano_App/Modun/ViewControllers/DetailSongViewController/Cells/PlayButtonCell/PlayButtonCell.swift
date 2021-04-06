//
//  PlayButtonCell.swift
//  Piano_App
//
//  Created by Azibai on 30/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol PlayButtonCellDelegate: class {
    
}

class PlayButtonCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 36
    }
    
    override func getCellName() -> String {
        return PlayButtonCell.className
    }
}

class PlayButtonCell: CellModelView<PlayButtonCellModel> {
    
    weak var delegate: PlayButtonCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? PlayButtonCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: PlayButtonCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
}



