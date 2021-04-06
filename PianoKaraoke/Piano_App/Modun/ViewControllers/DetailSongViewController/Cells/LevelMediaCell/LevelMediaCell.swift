//
//  LevelMediaCell.swift
//  Piano_App
//
//  Created by Azibai on 15/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol LevelMediaCellDelegate: class {
    
}

class LevelMediaCellModel: AziBaseCellModel {
    
    var numberStart: Int = 5
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 20
    }
    
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth - 30
    }
    override func getCellName() -> String {
        return LevelMediaCell.className
    }
}

class LevelMediaCell: CellModelView<LevelMediaCellModel> {
    
    weak var delegate: LevelMediaCellDelegate?
    
    @IBOutlet weak var levelView: Level!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? LevelMediaCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: LevelMediaCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        levelView.config(numberStars: cellModel.numberStart)
    }
    
}



