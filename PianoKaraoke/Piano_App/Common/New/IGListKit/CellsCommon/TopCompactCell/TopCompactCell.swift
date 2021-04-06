//
//  TopCompactCell.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//
import UIKit

class TopCompactCell: CellModelView<TopCompactCellModel>  {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


public class TopCompactCellModel: AziBaseCellModel {
    
    
    public override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 4
        
    }
    
//    public func getCellName() -> String {
//        return "TopCompactCell"
//    }
//    
//    public func getData() -> Any? {
//        return nil
//    }
}
