//
//  HeaderCommentDetailSongCell.swift
//  Piano_App
//
//  Created by Azibai on 15/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol HeaderCommentDetailSongCellDelegate: class {
    
}

class HeaderCommentDetailSongCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 55
    }
    
    override func getCellName() -> String {
        return HeaderCommentDetailSongCell.className
    }
}

class HeaderCommentDetailSongCell: CellModelView<HeaderCommentDetailSongCellModel> {
    
    weak var delegate: HeaderCommentDetailSongCellDelegate?
    
    @IBOutlet weak var containerView: UIView!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? HeaderCommentDetailSongCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: HeaderCommentDetailSongCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        containerView.roundCorners([.topLeft, .topRight], radius: 12)
    }
    
}



