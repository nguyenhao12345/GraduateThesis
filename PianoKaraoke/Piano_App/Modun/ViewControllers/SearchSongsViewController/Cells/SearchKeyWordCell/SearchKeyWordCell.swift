//
//  SearchKeyWordCell.swift
//  Piano_App
//
//  Created by Azibai on 13/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import DTCoreText

protocol SearchKeyWordCellDelegate: class {
    
}

class SearchKeyWordCellModel: AziBaseCellModel {
    
    var attributed: NSMutableAttributedString?
    var key: String = ""
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 28
    }
    
    override func getCellName() -> String {
        return SearchKeyWordCell.className
    }
}

class SearchKeyWordCell: CellModelView<SearchKeyWordCellModel> {
    
    weak var delegate: SearchKeyWordCellDelegate?
    
    @IBOutlet weak var coreText: DTAttributedLabel!
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? SearchKeyWordCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: SearchKeyWordCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        coreText.attributedString = cellModel.attributed
    }
    
}



