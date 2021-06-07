//
//  BlankSpaceCell.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import UIKit

class BlankSpaceCell: CellModelView<BlankSpaceCellModel> {
    
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: BlankSpaceCellModel) {
        super.bindCellModel(cellModel)
//        self.backgroundColor = cellModel.color
        self.backView.backgroundColor = cellModel.color
    }
    
}

public class BlankSpaceCellModel: AziBaseCellModel {
    
    var height:CGFloat = 8
    var width: CGFloat?
    var color: UIColor = UIColor.white
    
    init(height: CGFloat, _width: CGFloat? = nil) {
        self.height = height
        self.width = _width
        super.init()
    }
    
    public override init() {
        super.init()
    }
    
    public override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return height
    }
    public override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        if width == nil {
            return maxWidth
        }
        else {
            return width ?? maxWidth
        }
    }
    
    //    public func getCellName() -> String {
    //        return "BlankSpaceCell"
    //    }
    //
    //    public func getData() -> Any? {
    //        return nil
    //    }
}
