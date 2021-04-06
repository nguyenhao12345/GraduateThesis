//
//  ReactionMusicCell.swift
//  Piano_App
//
//  Created by Azibai on 15/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol ReactionMusicCellDelegate: class {
    
}

class ReactionMusicCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 80
    }
    
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth - 30
    }
    override func getCellName() -> String {
        return ReactionMusicCell.className
    }
}

class ReactionMusicCell: CellModelView<ReactionMusicCellModel> {
    
    weak var delegate: ReactionMusicCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? ReactionMusicCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: ReactionMusicCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
}



