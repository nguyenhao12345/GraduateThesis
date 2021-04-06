//
//  SearchGlobalCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol SearchGlobalCellDelegate: class {
    
}

class SearchGlobalCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 44
    }
    
    override func getCellName() -> String {
        return SearchGlobalCell.className
    }
}

class SearchGlobalCell: CellModelView<SearchGlobalCellModel> {
    
    weak var delegate: SearchGlobalCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? SearchGlobalCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: SearchGlobalCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
}



