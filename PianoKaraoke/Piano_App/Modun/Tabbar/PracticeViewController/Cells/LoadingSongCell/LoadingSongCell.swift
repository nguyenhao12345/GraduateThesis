//
//  LoadingSongCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Shimmer

protocol LoadingSongCellDelegate: class {
    
}

class LoadingSongCellModel: AziBaseCellModel {
    
    var height: CGFloat = 0
    var width: CGFloat = 0
    init(height: CGFloat, width: CGFloat) {
        self.height = height
        self.width = width
        super.init()
    }
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return height
    }
    
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return width
    }
    
    override func getCellName() -> String {
        return LoadingSongCell.className
    }
}

class LoadingSongCell: CellModelView<LoadingSongCellModel> {
    
    
    @IBOutlet weak var shimmeringView: FBShimmeringView!
    @IBOutlet var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let contentView = self.containerView
        self.shimmeringView.contentView = containerView
        contentView?.frame = self.shimmeringView.bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.shimmeringView.isShimmering = true
    }
    
}



