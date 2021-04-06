//
//  ManualLoadingCellModel.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import UIKit


public protocol ManualLoadingCellDelegate:class {
    func manualLoadingCellLoad()
}

public class ManualLoadingCell: CellModelView<ManualLoadingCellModel> {
    public weak var delegate: ManualLoadingCellDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func loadMore(_ sender: UIButton) {
        self.delegate?.manualLoadingCellLoad()
    }
}

public class ManualLoadingCellModel: AziBaseCellModel {
    public override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 30
    }
    
}

