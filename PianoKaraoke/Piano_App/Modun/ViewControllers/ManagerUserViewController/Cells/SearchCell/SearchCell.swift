//
//  SearchCell.swift
//  Piano_App
//
//  Created by Azibai on 23/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol SearchCellDelegate: class {
    
}

class SearchCellModel: AziBaseCellModel {
    var textSearch: String = ""

    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 44
    }
    
    override func getCellName() -> String {
        return SearchCell.className
    }
}

class SearchCell: CellModelView<SearchCellModel> {
    
    weak var delegate: SearchCellDelegate?
    
    @IBOutlet weak var containerView: ViewRound!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? SearchCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: SearchCellModel) {
        super.bindCellModel(cellModel)
                // border
                containerView.layer.borderWidth = 1.0
                containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor

                // shadow
                containerView.layer.shadowColor = UIColor.black.cgColor
                containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
                containerView.layer.shadowOpacity = 0.1
                containerView.layer.shadowRadius = 4.0

    }
    
}



