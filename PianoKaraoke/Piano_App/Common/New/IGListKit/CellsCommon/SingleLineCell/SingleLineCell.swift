//
//  SingleLineCellModel.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import UIKit

public class SingleLineCell: CellModelView<TopCompactCellModel>  {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


public class SingleLineCellModel: AziBaseCellModel {
    
    
    public override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 1
        
    }
    
    //    public func getCellName() -> String {
    //        return "SingleLineCell"
    //    }
    //
    //    public func getData() -> Any? {
    //        return nil
    //    }
}


