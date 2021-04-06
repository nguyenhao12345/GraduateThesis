//
//  HotKeyWordCell.swift
//  Piano_App
//
//  Created by Azibai on 13/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol HotKeyWordCellDelegate: class {
    
}

class HotKeyWordCellModel: AziBaseCellModel {
    var height: CGFloat = 0
    var width: CGFloat = 0
    var text: String = ""
    var hexColorBackground: String = "FAFAFA"
    init(height: CGFloat, width: CGFloat, text: String, hexColorBackground: String) {
        self.text = text
        self.height = height
        self.width = width
        self.hexColorBackground = hexColorBackground
    }
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return height
    }
        
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return width
    }
    
    override func getCellName() -> String {
        return HotKeyWordCell.className
    }
}

class HotKeyWordCell: CellModelView<HotKeyWordCellModel> {
    
    weak var delegate: HotKeyWordCellDelegate?
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var viewContainer: UIView!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? HotKeyWordCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: HotKeyWordCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        textLbl.text = cellModel.text
        viewContainer.backgroundColor = UIColor(hexString: cellModel.hexColorBackground)
    }
    
}



