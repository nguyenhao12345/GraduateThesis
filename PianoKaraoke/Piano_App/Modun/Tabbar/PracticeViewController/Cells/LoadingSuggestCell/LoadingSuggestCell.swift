//
//  LoadingSuggestCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Shimmer

protocol LoadingSuggestCellDelegate: class {
    
}

class LoadingSuggestCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 80
    }
    
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth - 44
    }
    override func getCellName() -> String {
        return LoadingSuggestCell.className
    }
}

class LoadingSuggestCell: CellModelView<LoadingSuggestCellModel> {
    
    weak var delegate: LoadingSuggestCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? LoadingSuggestCellDelegate
    }
    
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



